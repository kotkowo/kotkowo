#![allow(non_camel_case_types)]


pub use self::adopted_cat_list_query::*;
use crate::error::{Error, Result};
use crate::model::cat::*;
use crate::model::{AdoptedCat, Cat, GalleryImage};
use crate::primitives::DateTime;
use graphql_client::GraphQLQuery;


#[derive(GraphQLQuery)]
#[graphql(
    schema_path = "src/query/schema.json",
    query_path = "src/query/list_adopted_cat.graphql",
    response_derives = "Debug,Clone"
)]
pub struct AdoptedCatListQuery;
impl TryFrom<AdoptedCatListQueryAdoptedCats> for Vec<AdoptedCat> {
    type Error = Error;

    fn try_from(value: AdoptedCatListQueryAdoptedCats) -> Result<Self> {
        let adopted_cats: Result<Vec<AdoptedCat>> = value.data.into_iter().map(|adopted_cat| {
            let id: usize = adopted_cat
                .id
                .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].id".to_string()))?
                .parse()?;
            let adopted_attributes = adopted_cat.attributes.ok_or_else(|| {
                Error::AttributeMissing("adoptedcatlistquery.data.[n].attributes".to_string())
            })?;
            let cat: Result<Cat> = {
                let inner_cat = adopted_attributes.cat.ok_or_else(|| {
                    Error::AttributeMissing(
                        "adoptedcatlistquery.data.[n].attributes.cat".to_string(),
                    )
                })?.data.ok_or_else(|| Error::AttributeMissing("adopted_cat.cat.data".to_string()))?;
                let id: usize = inner_cat
                .id
                .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].id".to_string()))?
                .parse()?;

                let attributes = inner_cat
                    .attributes
                    .ok_or_else(|| Error::AttributeMissing("innercat.attributes".to_string()))?;
                let gallery: Result<Vec<GalleryImage>> = attributes
                    .images
                    .ok_or_else(|| {
                        Error::AttributeMissing(
                            "CatListQuery.data.[n].attributes.images".to_string(),
                        )
                    })?
                    .data
                    .into_iter()
                    .map(|image| {
                        let attributes = image
                            .attributes
                            .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].attributes.images.data.[n].attributes".to_string()))?
                            .image
                            .data
                            .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].attributes.images.data.[n].attributes.image.data".to_string()))?
                            .attributes
                            .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].attributes.images.data.[n].attributes.image.data.attributes".to_string()))?;

                        Ok(GalleryImage {
                            name: attributes.name,
                            ext: attributes.ext,
                            hash: attributes.hash,
                            alternative_text: attributes.alternative_text,
                        })
                    })
                    .collect();


                let tags: Result<Vec<String>> = 
                    attributes.cat_tags
                    .ok_or_else(|| Error::AttributeMissing("CatListQuery.data.[n].attributes.cat_tags".to_string()))?
                    .data.into_iter().map(|tag| tag.try_into()).collect();

                let gallery = gallery?;
                let tags = tags?;

                Ok(Cat {
                    id,
                    gallery,
                    tags,
                    name: attributes.name,
                    description_heading: attributes.description_heading,
                    description: attributes.description,
                    slug: attributes.slug,
                    sex: attributes.sex.into(),
                    age: attributes.age.into(),
                    healthy: attributes.healthy.into(),
                    fiv_felv: attributes.fiv_felv.into(),
                    castrated: attributes.castrated.into(),
                    medical_status: attributes.medical_status.into(),
                    created_at: attributes.created_at,
                    updated_at: attributes.updated_at,
                    published_at: attributes.published_at,
                })

            };
            let adoption_date = adopted_attributes.adoption_date;
            Ok(AdoptedCat {
                id,
                cat: cat?,
                adoption_date
            })
        }).collect();
    adopted_cats
    }
}

impl From<ENUM_CAT_AGE> for Age {
    fn from(value: ENUM_CAT_AGE) -> Self {
        match value {
            ENUM_CAT_AGE::Junior => Age {
                value: age::enums::Age::Junior,
            },
            ENUM_CAT_AGE::Adult => Age {
                value: age::enums::Age::Adult,
            },
            ENUM_CAT_AGE::Senior => Age {
                value: age::enums::Age::Senior,
            },
            ENUM_CAT_AGE::Other(_) => Age {
                value: age::enums::Age::Adult,
            },
        }
    }
}

impl From<ENUM_CAT_SEX> for Sex {
    fn from(value: ENUM_CAT_SEX) -> Self {
        match value {
            ENUM_CAT_SEX::Female => Sex {
                value: sex::enums::Sex::Female,
            },
            ENUM_CAT_SEX::Male => Sex {
                value: sex::enums::Sex::Male,
            },
            ENUM_CAT_SEX::Other(_) => Sex {
                value: sex::enums::Sex::Male,
            },
        }
    }
}

impl From<ENUM_CAT_FIV_FELV> for FivFelv {
    fn from(value: ENUM_CAT_FIV_FELV) -> Self {
        match value {
            ENUM_CAT_FIV_FELV::Negative => FivFelv {
                value: fiv_felv::enums::FivFelv::Negative,
            },
            ENUM_CAT_FIV_FELV::Positive => FivFelv {
                value: fiv_felv::enums::FivFelv::Positive,
            },
            ENUM_CAT_FIV_FELV::Other(_) => FivFelv {
                value: fiv_felv::enums::FivFelv::Negative,
            },
        }
    }
}

impl From<ENUM_CAT_MEDICAL_STATUS> for MedicalStatus {
    fn from(value: ENUM_CAT_MEDICAL_STATUS) -> Self {
        match value {
            ENUM_CAT_MEDICAL_STATUS::TestedAndVaccinated => MedicalStatus {
                value: medical_status::enums::MedicalStatus::TestedAndVaccinated,
            },
            ENUM_CAT_MEDICAL_STATUS::Other(_) => MedicalStatus {
                value: medical_status::enums::MedicalStatus::TestedAndVaccinated,
            },
        }
    }
}

impl TryInto<String> for AdoptedCatListQueryAdoptedCatsDataAttributesCatDataAttributesCatTagsData {
    type Error = Error;

    fn try_into(self) -> Result<String> {
        Ok(self.attributes.ok_or_else(|| Error::AttributeMissing("CatListQueryCatsDataAttributesCatTagsData.attributes".to_string()))?.text.to_string())
    }
}
