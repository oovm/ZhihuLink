#![feature(try_blocks)]
#![feature(lazy_cell)]

mod bilibili;
mod errors;
pub mod utils;
mod dispatch;
mod zhihu;
mod emath;

pub use crate::{zhihu::answers::ZhihuAnswer, zhihu::auto::AutoMarkdown, bilibili::article::BilibiliArticle, zhihu::zhuanlans::ZhihuArticle, dispatch::UrlDispatcher, emath::EMathDissussion};
pub use errors::{MarkResult, ZhihuError};
