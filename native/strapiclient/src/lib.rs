mod error;
mod model;
mod primitives;
mod query;

use crate::error::{Error, Result};
use crate::model::cat::Cat;
use crate::query::get_cat::{
    CatGetQuery, ResponseData as CatGetResponseData, Variables as CatGetVariables,
};
use crate::query::list_cat::{
    CatListQuery, ResponseData as CatListResponseData, Variables as CatListVariables,
};
/* use crate::query::cat::{cat_get_query, cat_list_query, CatGetQuery, CatListQuery}; */
use graphql_client::{GraphQLQuery, Response};
use std::env;

fn get_client() -> Result<reqwest::blocking::Client> {
    let api_key = env::var("STRAPI_KEY")?;
    let mut headers = reqwest::header::HeaderMap::with_capacity(1);
    headers.insert(
        reqwest::header::AUTHORIZATION,
        format!("Bearer {}", api_key).parse()?,
    );
    let client = reqwest::blocking::Client::builder()
        .default_headers(headers)
        .build()?;

    Ok(client)
}

fn run_query<QB: serde::Serialize, R: for<'a> serde::Deserialize<'a>>(
    query_body: &graphql_client::QueryBody<QB>,
) -> Result<Response<R>> {
    let client = get_client()?;
    let endpoint = env::var("STRAPI_ENDPOINT")?;

    Ok(client.post(endpoint).json(query_body).send()?.json()?)
}

#[rustler::nif]
fn list_cats() -> Result<Vec<Cat>> {
    let query = CatListQuery::build_query(CatListVariables);
    let cat: Vec<Cat> = match run_query(&query)?.data {
        Some(CatListResponseData {
            cats: Some(cats), ..
        }) => cats.try_into()?,
        _ => Err(Error::MissingData)?,
    };

    Ok(cat)
}

#[rustler::nif]
fn get_cat(slug: &str) -> Result<Cat> {
    let slug = Some(slug.to_owned());
    let query = CatGetQuery::build_query(CatGetVariables { slug });
    let cat: Cat = match run_query(&query)?.data {
        Some(CatGetResponseData {
            cats: Some(cats), ..
        }) => cats.try_into()?,
        _ => Err(Error::MissingData)?,
    };

    Ok(cat)
}

rustler::init!("Elixir.Kotkowo.StrapiClient", [list_cats, get_cat]);
