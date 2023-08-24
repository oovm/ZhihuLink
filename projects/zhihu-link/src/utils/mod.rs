use crate::MarkResult;
use htmler::{Html, Selector};
use std::{io::Write, path::Path};

/// 选择首个符合选择器的节点的文本内容, 该节点需要是**纯文本节点**
///
/// 节点不存在或者非文本节点都会返回 None, 且复杂文本节点只会返回第一段
pub fn select_text(html: &Html, selector: &Selector) -> Option<String> {
    let node = html.select_one(selector)?;
    let text = node.first_child()?.as_text()?;
    Some(text.to_string())
}

pub fn save_string<P>(path: P, s: &str) -> MarkResult<()>
where
    P: AsRef<Path>,
{
    let mut file = std::fs::File::create(path)?;
    file.write_all(s.as_bytes())?;
    Ok(())
}
