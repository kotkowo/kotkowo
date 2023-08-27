use rustler::NifStruct;

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.GalleryImage"]
pub struct GalleryImage {
    pub hash: String,
    pub ext: Option<String>,
    pub name: String,
    pub alternative_text: Option<String>,
}
