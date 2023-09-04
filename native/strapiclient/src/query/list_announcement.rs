pub use self::list_announcement_query::*;
use crate::{
    error::{Error, Result},
    model::{Announcement, GalleryImage},
};
use graphql_client::GraphQLQuery;

#[derive(GraphQLQuery)]
#[graphql(
    schema_path = "src/query/schema.json",
    query_path = "src/query/list_announcement.graphql",
    response_derives = "Debug,Clone"
)]
pub struct ListAnnouncementQuery;

impl TryFrom<ListAnnouncementQueryAnnouncements> for Vec<Announcement> {
    type Error = Error;
    fn try_from(value: ListAnnouncementQueryAnnouncements) -> Result<Self> {
        let announcements: Result<Vec<Announcement>> = value
            .data
            .into_iter()
            .map(|announcement| {
                let id: usize = announcement
                    .id
                    .ok_or_else(|| {
                        Error::AttributeMissing("AnnouncementListQuery.data.[n].id".to_string())
                    })?
                    .parse()?;

                let attributes = announcement.attributes.ok_or_else(|| {
                    Error::AttributeMissing("AnnouncementListQuery.data.[n].attributes".to_string())
                })?;
                let tags: Result<Vec<String>> = attributes
                    .announcement_tags
                    .ok_or_else(|| {
                        Error::AttributeMissing(
                            "AnnouncementListQuery.data.[n].attributes.announcement_tags"
                                .to_string(),
                        )
                    })?
                    .data
                    .into_iter()
                    .map(|data| {
                        Ok(data
                            .attributes
                            .ok_or_else(|| {
                                Error::AttributeMissing(
                                    "AnnouncementListQuery.data.[n].attributes".to_string(),
                                )
                            })?
                            .text)
                    })
                    .collect();
                let image: Result<GalleryImage> = {
                    let inner_attr = attributes
                        .image
                        .data
                        .ok_or_else(|| {
                            Error::AttributeMissing(
                                "AnnouncementListQuery.data.[n].attributes.image.data".to_string(),
                            )
                        })?
                        .attributes
                        .ok_or_else(|| {
                            Error::AttributeMissing(
                                "AnnouncementListQuery.data.[n].attributes.image.data.attributes"
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

                let image = image?;
                let tags = tags?;

                Ok(Announcement {
                    id,
                    title: attributes.title,
                    tags,
                    image,
                })
            })
            .collect();
        Ok(announcements?)
        //let announcements: Result<Vec<Announcement>> = value.data.into_iter()
    }
}
