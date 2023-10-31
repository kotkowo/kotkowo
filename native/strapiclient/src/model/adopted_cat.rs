use crate::model::{Cat, GalleryImage};
use rustler::NifStruct;

use crate::primitives::DateTime;

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.AdoptedCat"]
pub struct AdoptedCat {
    pub id: usize,
    pub cat: Cat,
    pub adoption_date: DateTime,
}
