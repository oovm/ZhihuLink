use crate::{
    utils::{save_string, select_text},
    MarkResult, ZhihuError,
};
use htmler::{Html, Node, NodeKind, Selector};
use std::{
    fmt::{Display, Formatter, Write},
    path::Path,
    str::FromStr,
    sync::LazyLock,
};

#[derive(Debug)]
pub struct BilibiliArticle {
    title: String,
    content: String,
}

impl Default for BilibiliArticle {
    fn default() -> Self {
        Self { title: "".to_string(), content: "".to_string() }
    }
}

impl Display for BilibiliArticle {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "# {}\n\n{}", self.title, self.content)
    }
}

impl FromStr for BilibiliArticle {
    type Err = ZhihuError;

    fn from_str(html: &str) -> Result<Self, Self::Err> {
        let mut empty = Self::default();
        empty.do_parse(html)?;
        Ok(empty)
    }
}

static SELECT_TITLE: LazyLock<Selector> = LazyLock::new(|| Selector::parse("p.inner-title").unwrap());
static SELECT_CONTENT: LazyLock<Selector> = LazyLock::new(|| Selector::parse("div.read-article-holder").unwrap());


static QUESTION_RICH_TEXT: LazyLock<Selector> = LazyLock::new(|| Selector::parse("div.QuestionRichText").unwrap());


// script#js-initialData

impl BilibiliArticle {
    /// 通过问题 ID 和回答 ID 获取知乎回答, 并渲染为 markdown
    ///
    /// # Examples
    ///
    /// ```
    /// # use zhihu_link::ZhihuAnswer;
    /// let answer = ZhihuAnswer::new(58151047, 1).await?;
    /// ```
    pub async fn new(article: usize) -> MarkResult<Self> {
        let html = Self::request(article).await?;
        Ok(html.parse()?)
    }
    pub async fn request(article: usize) -> MarkResult<String> {
        let url = format!("https://www.bilibili.com/read/cv{article}");
        let resp = reqwest::Client::new().get(url).send().await?;
        Ok(resp.text().await?)
    }
    pub fn save<P>(&self, path: P) -> MarkResult<()>
        where
            P: AsRef<Path>,
    {
        save_string(path, &self.to_string())
    }
    fn do_parse(&mut self, html: &str) -> MarkResult<()> {
        let html = Html::parse_document(html);
        self.extract_title(&html)?;
        self.extract_description(&html)?;
        self.extract_content(&html)?;
        Ok(())
    }
    fn extract_title(&mut self, html: &Html) -> MarkResult<()> {
        let title = select_text(&html, &SELECT_TITLE).unwrap_or_default();
        self.title = title.replace("\r", "").replace("\n", "");
        Ok(())
    }
    fn extract_description(&mut self, html: &Html) -> MarkResult<()> {
        let _: Option<_> = try {
            for node in html.select(&QUESTION_RICH_TEXT) {
                let text = node.first_child()?.as_text()?;
                println!("text: {:?}", text);
            }
        };
        Ok(())
    }
    fn extract_content(&mut self, html: &Html) -> MarkResult<()> {
        match html.select_one(&SELECT_CONTENT) {
            Some(s) => {
                for child in s.children() {
                    self.read_content_node(child)?;
                }
            }
            None => {
                tracing::warn!("content not found");
            }
        };
        Ok(())
    }
    fn read_content_node(&mut self, node: Node) -> MarkResult<()> {
        match node.as_kind() {
            NodeKind::Document => {
                println!("document")
            }
            NodeKind::Fragment => {
                println!("fragment")
            }
            NodeKind::Doctype(_) => {
                println!("doctype")
            }
            NodeKind::Comment(_) => {
                println!("comment")
            }
            NodeKind::Text(t) => {
                self.content.push_str(t.trim());
            }
            NodeKind::Element(e) => {
                match e.name() {
                    "h1" => {
                        self.content.push_str("# ");
                        self.content.push_str(&node.text().next().map(|s| s.trim()).unwrap_or_default());
                        // self.content.push_str("\n\n");
                    }
                    "strong" => {
                        self.content.push_str("**");
                        for child in node.children() {
                            self.read_content_node(child)?;
                        }
                        self.content.push_str("**");
                    }
                    "p" => {
                        for child in node.children() {
                            self.read_content_node(child)?;
                        }
                        self.content.push_str("\n\n");
                    }
                    "span" => {
                        // math mode
                        if e.has_class("ztext-math") {
                            match e.get_attribute("data-tex") {
                                Some(s) => {
                                    self.content.push_str(" $$");
                                    self.content.push_str(s);
                                    self.content.push_str("$$ ");
                                }
                                None => {}
                            }
                        }
                        // normal mode
                        else {
                            for child in node.children() {
                                self.read_content_node(child)?;
                            }
                        }
                    }
                    "a" => {
                        let href = node.get_attribute("href");
                        self.content.push_str("[");
                        for child in node.children() {
                            self.read_content_node(child)?;
                        }
                        write!(self.content, "]({})", href)?;
                    }
                    "br" => {
                        self.content.push_str("\n");
                    }
                    "figure" => {
                        for child in node.descendants().filter(|e| e.is_a("img")) {
                            let original = child.get_attribute("data-src");
                            if !original.is_empty() {
                                write!(self.content, "![](https:{})\n\n", original)?;
                                break;
                            }
                        }
                    }
                    "code" => {
                        self.content.push_str(" `");
                        for child in node.children() {
                            self.read_content_node(child)?;
                        }
                        self.content.push_str("` ");
                    }
                    "ol" => {
                        for (i, child) in node.children().enumerate() {
                            write!(self.content, "{}. ", i + 1)?;
                            for child in child.children() {
                                self.read_content_node(child)?;
                            }
                            self.content.push_str("\n");
                        }
                    }
                    "ul" => {
                        for child in node.children() {
                            self.content.push_str("- ");
                            for child in child.children() {
                                self.read_content_node(child)?;
                            }
                            self.content.push_str("\n");
                        }
                    }
                    "blockquote" => {
                        for child in node.children() {
                            self.content.push_str("> ");
                            for child in child.children() {
                                self.read_content_node(child)?;
                            }
                            self.content.push_str("\n");
                        }
                    }

                    unknown => panic!("unknown element: {unknown}"),
                }
            }
            NodeKind::ProcessingInstruction(_) => {
                println!("processing instruction");
            }
        }
        Ok(())
    }
}
