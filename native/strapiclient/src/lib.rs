mod error;
mod model;
mod primitives;
mod query;

use crate::error::{Error, Result};
use crate::model::{AdoptedCat, Announcement, Article, Cat};
use crate::query::get_article_for_announcement::{
    AnnouncementArticleQuery, ResponseData as ArticleResponseData, Variables as ArticleGetVariables,
};
use crate::query::list_adopted_cat::{
    AdoptedCatListQuery, ResponseData as AdoptedCatResponseData,
    Variables as AdoptedCatListVariables,
};

use crate::query::get_cat::{
    CatGetQuery, ResponseData as CatGetResponseData, Variables as CatGetVariables,
};
use crate::query::list_announcement::{
    ListAnnouncementQuery, ResponseData as ListAnnouncementResponseData,
    Variables as ListAnnouncementVariables,
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
fn list_cats(
    is_dead: Option<bool>,
    is_adopted: Option<bool>,
    limit: Option<i64>,
    offset: Option<i64>,
) -> Result<Vec<Cat>> {
    let query = CatListQuery::build_query(CatListVariables {
        limit,
        offset,
        is_dead,
    });
    let cat: Vec<Cat> = match run_query(&query)?.data {
        Some(CatListResponseData {
            cats: Some(cats), ..
        }) => cats.try_into()?,
        _ => Err(Error::MissingData)?,
    };
    let filtered_cats: Vec<Cat> = cat
        .into_iter()
        .filter(|c| {
            if let Some(value) = is_adopted {
                c.is_adopted == value
            } else {
                true
            }
        })
        .collect();
    Ok(filtered_cats)
}
#[rustler::nif]
fn list_adopted_cats(limit: Option<i64>, offset: Option<i64>) -> Result<Vec<AdoptedCat>> {
    let query = AdoptedCatListQuery::build_query(AdoptedCatListVariables { limit, offset });
    let cat: Vec<AdoptedCat> = match run_query(&query)?.data {
        Some(AdoptedCatResponseData {
            cats: Some(adopted_cats),
            ..
        }) => adopted_cats.try_into()?,
        _ => Err(Error::MissingData)?,
    };

    Ok(cat)
}

#[rustler::nif]
fn list_adopted_cats_pages(limit: Option<i64>, offset: Option<i64>) -> Result<i64> {
    let query = AdoptedCatListQuery::build_query(AdoptedCatListVariables { limit, offset });
    let pages: i64 = match run_query(&query)?.data {
        Some(AdoptedCatResponseData {
            cats: Some(adopted_cats),
            ..
        }) => adopted_cats.meta.pagination.page_count,
        _ => Err(Error::MissingData)?,
    };

    Ok(pages)
}
#[rustler::nif]
fn get_announcement_list_pages(num_items: Option<i64>, offset: Option<i64>) -> Result<i64> {
    let query = ListAnnouncementQuery::build_query(ListAnnouncementVariables {
        limit: num_items,
        offset,
    });
    let pages: i64 = match run_query(&query)?.data {
        Some(ListAnnouncementResponseData {
            announcements: Some(announcements),
            ..
        }) => announcements.meta.pagination.page_count,
        _ => Err(Error::MissingData)?,
    };
    Ok(pages)
}

#[rustler::nif]
fn list_announcements(num_items: Option<i64>, offset: Option<i64>) -> Result<Vec<Announcement>> {
    let query = ListAnnouncementQuery::build_query(ListAnnouncementVariables {
        limit: num_items,
        offset,
    });
    let announcements: Vec<Announcement> = match run_query(&query)?.data {
        Some(ListAnnouncementResponseData {
            announcements: Some(announcements),
            ..
        }) => announcements.try_into()?,
        _ => Err(Error::MissingData)?,
    };
    Ok(announcements)
}

#[rustler::nif]
fn get_article_for_announcement(announcement_id: Option<String>) -> Result<Article> {
    let query = AnnouncementArticleQuery::build_query(ArticleGetVariables { announcement_id });
    let article: Article = match run_query(&query)?.data {
        Some(ArticleResponseData {
            announcement: Some(announcement),
        }) => announcement.try_into()?,
        _ => Err(Error::MissingData)?,
    };
    Ok(article)
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

rustler::init!(
    "Elixir.Kotkowo.StrapiClient",
    [
        list_adopted_cats,
        list_cats,
        get_cat,
        list_announcements,
        get_article_for_announcement,
        get_announcement_list_pages,
        list_adopted_cats_pages,
    ]
);
