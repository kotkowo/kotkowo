use crate::model::GalleryImage;
use rustler::NifStruct;

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.Announcement"]
pub struct Announcement {
    pub id: usize,
    pub title: String,
    pub tags: Vec<String>,
    pub image: GalleryImage,
}
