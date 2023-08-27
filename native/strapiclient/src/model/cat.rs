use crate::model::GalleryImage;
use rustler::NifStruct;

use crate::primitives::DateTime;

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.Cat"]
pub struct Cat {
    pub id: usize,
    pub slug: String,
    pub name: String,
    pub gallery: Vec<GalleryImage>,
    pub description_heading: String,
    pub description: String,
    pub created_at: Option<DateTime>,
    pub updated_at: Option<DateTime>,
    pub published_at: Option<DateTime>,
    pub sex: Sex,
    pub age: Age,
    pub medical_status: MedicalStatus,
    pub fiv_felv: FivFelv,
    pub castrated: Castrated,
    pub healthy: Healthy,
    pub tags: Vec<String>,
}

macro_rules! attr_enum{
    ( $mod_name:ident, $name:ident, $module:literal, $( $variant:ident ),* ) => {
        pub mod $mod_name {
            pub mod enums {
                use rustler::NifUnitEnum;
                #[derive(Debug, NifUnitEnum)]

                pub enum $name {
                    $(
                        $variant,
                    )*
                }
            }

        }

        #[derive(Debug, NifStruct)]
        #[module = $module]
        pub struct $name{pub value: self::$mod_name::enums::$name}
    }
}

attr_enum![sex, Sex, "Kotkowo.Cat.Sex", Male, Female];

attr_enum![age, Age, "Kotkowo.Cat.Age", Junior, Adult, Senior];

attr_enum![
    medical_status,
    MedicalStatus,
    "Kotkowo.Cat.MedicalStatus",
    TestedAndVaccinated
];

attr_enum![fiv_felv, FivFelv, "Kotkowo.Cat.FivFelv", Positive, Negative];

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.Cat.Castrated"]
pub struct Castrated {
    value: bool,
}

impl From<bool> for Castrated {
    fn from(value: bool) -> Self {
        Self { value }
    }
}

#[derive(Debug, NifStruct)]
#[module = "Kotkowo.Cat.Healthy"]
pub struct Healthy {
    value: bool,
}

impl From<bool> for Healthy {
    fn from(value: bool) -> Self {
        Self { value }
    }
}
