use std::sync::LazyLock;
use htmler::Selector;

pub mod answers;
pub mod auto;
pub mod zhuanlans;

static QUESTION_RICH_TEXT: LazyLock<Selector> = LazyLock::new(|| Selector::parse("div.QuestionRichText").unwrap());