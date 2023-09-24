pub use self::announcement_article_query::*;
use crate::{
    error::{Error, Result},
    model::{Article, GalleryImage},
};

use graphql_client::GraphQLQuery;

#[derive(GraphQLQuery)]
#[graphql(
    schema_path = "src/query/schema.json",
    query_path = "src/query/get_article_for_announcement.graphql",
    response_derives = "Debug,Clone"
)]
pub struct AnnouncementArticleQuery;

impl TryFrom<AnnouncementArticleQueryAnnouncement> for Article {
    type Error = Error;
    fn try_from(value: AnnouncementArticleQueryAnnouncement) -> Result<Self> {
        let announcement = value.data.ok_or_else(|| Error::NotFound);
        let announcement_attributes = announcement?.attributes.ok_or_else(|| {
            Error::AttributeMissing("AnnouncementArticleQuery.data.[n].attributes".to_string())
        })?;
        let article = announcement_attributes.article.ok_or_else(|| {
            Error::AttributeMissing("AnnouncementArticleQuery.data.attributes.article".to_string())
        })?;
        let article_data = article.data.ok_or_else(|| Error::NotFound)?;
        let attributes = article_data.attributes.ok_or_else(|| {
            Error::AttributeMissing(
                "AnnouncementArticleQuery.data.[n].attributes.article.data.article_data"
                    .to_string(),
            )
        })?;
        let title: String = {
            attributes
                .announcement
                .ok_or_else(|| {
                    Error::AttributeMissing(
                        "AnnouncementArticleQuery.data.[n].attributes.article.data.announcement"
                            .to_string(),
                    )
                })?
                .data.ok_or_else(|| {
                    Error::AttributeMissing(
                        "AnnouncementArticleQuery.data.[n].attributes.article.data.announcement.data"
                            .to_string(),
                    )
                })?.attributes.ok_or_else(|| {
                    Error::AttributeMissing(
                        "AnnouncementArticleQuery.data.[n].attributes.article.data.announcement.data.attributes"
                            .to_string(),
                    )
                })?.title
        };
        let image: Result<GalleryImage> = {
            let inner_attr = attributes
                .image
                .data
                .ok_or_else(|| {
                    Error::AttributeMissing(
                        "AnnouncementArticleQuery.data.[n].attributes.image.data".to_string(),
                    )
                })?
                .attributes
                .ok_or_else(|| {
                    Error::AttributeMissing(
                        "AnnouncementArticleQuery.data.[n].attributes.image.data.attributes"
                            .to_string(),
                    )
                })?;

            Ok(GalleryImage {
                hash: inner_attr.hash,
                ext: inner_attr.ext,
                name: inner_attr.name,
                alternative_text: inner_attr.alternative_text,
            })
        };
        Ok(Article {
            title,
            image: image?,
            introduction: attributes.introduction,
            content: attributes.content,
        })
    }
}
