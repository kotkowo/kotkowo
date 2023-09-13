use crate::model::GalleryImage;
use rustler::NifStruct;

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.Article"]
pub struct Article {
    pub title: String,
    pub introduction: String,
    pub content: String,
    pub image: GalleryImage,
}
