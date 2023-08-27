use rustler::Encoder;
use thiserror::Error;

#[derive(Error, Debug)]
#[error(transparent)]
pub enum Error {
    #[error("Request to strapi succeeded but no root data attribute was returned")]
    MissingData,
    SystemEnvMissing(#[from] std::env::VarError),
    Request(#[from] reqwest::Error),
    #[error("Missing attribute '{0}'")]
    AttributeMissing(String),
    ParseIntError(#[from] std::num::ParseIntError),
    InvalidHeaderValue(#[from] reqwest::header::InvalidHeaderValue),
    #[error("Not found")]
    NotFound,
}

mod error_atoms {
    rustler::atoms! {
        response_missing_data,
        system_env_missing,
        request_failed,
        attribute_missing,
        parse_error,
        not_found
    }
}
impl Encoder for Error {
    fn encode<'a>(&self, env: rustler::Env<'a>) -> rustler::Term<'a> {
        match self {
            err @ Error::MissingData => (error_atoms::response_missing_data(), err.to_string()),
            err @ Error::SystemEnvMissing(_) => {
                (error_atoms::system_env_missing(), err.to_string())
            }
            err @ Error::Request(_) => (error_atoms::request_failed(), err.to_string()),
            err @ Error::AttributeMissing(_) => (error_atoms::attribute_missing(), err.to_string()),
            err @ Error::ParseIntError(_) => (error_atoms::parse_error(), err.to_string()),
            err @ Error::InvalidHeaderValue(_) => (error_atoms::parse_error(), err.to_string()),
            err @ Error::NotFound => (error_atoms::not_found(), err.to_string()),
        }
        .encode(env)
    }
}

pub type Result<T> = std::result::Result<T, self::Error>;
