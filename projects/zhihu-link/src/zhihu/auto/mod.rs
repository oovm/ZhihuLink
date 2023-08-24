use crate::{MarkResult, ZhihuArticle};
use reqwest::IntoUrl;
use std::str::FromStr;

pub struct AutoMarkdown {}

impl AutoMarkdown {
    pub async fn new<S>(s: S) -> MarkResult<String>
    where
        S: IntoUrl,
    {
        let url = s.into_url()?;
        match url.path_segments() {
            Some(mut s) => match s.next() {
                Some("question") => {}
                Some("p") => {
                    match s.next() {
                        Some(s) => match usize::from_str(s) {
                            Ok(o) => {
                                let article = ZhihuArticle::new(o).await?;
                                return Ok(article.to_string());
                            }
                            Err(e) => {
                                println!("专栏 ID 解析错误: {:?}", e)
                            }
                        },
                        None => {
                            println!("找不到专栏 ID")
                        }
                    }

                    println!("专栏: {:?}", url);
                }
                Some(s) => {
                    println!("未知: {:?}", s);
                }
                None => {
                    panic!("url is not zhihu.com")
                }
            },
            None => {
                panic!("url is not zhihu.com")
            }
        }

        // let url = format!("https://www.zhihu.com/question/{question}/answer/{answer}");
        // let resp = reqwest::Client::new().get(url).send().await?;
        // Self {
        //
        // };
        Ok("".to_string())
    }
}
