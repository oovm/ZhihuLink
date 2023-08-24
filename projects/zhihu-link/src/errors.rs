#[derive(Debug, Clone)]
pub enum ZhihuError {
    DecodeError(String),
    SystemError(String),
    RequestError(String),
    UnknownError,
}

pub type MarkResult<T> = Result<T, ZhihuError>;

impl From<reqwest::Error> for ZhihuError {
    fn from(e: reqwest::Error) -> Self {
        ZhihuError::RequestError(e.to_string())
    }
}

impl From<std::io::Error> for ZhihuError {
    fn from(e: std::io::Error) -> Self {
        ZhihuError::SystemError(e.to_string())
    }
}

impl From<std::fmt::Error> for ZhihuError {
    fn from(e: std::fmt::Error) -> Self {
        ZhihuError::SystemError(e.to_string())
    }
}

impl From<serde_json::Error> for ZhihuError {
    fn from(e: serde_json::Error) -> Self {
        ZhihuError::DecodeError(e.to_string())
    }
}
