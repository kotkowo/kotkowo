use kotkowo_client::{
    list_announcement, list_cat, Announcement, AnnouncementFilter, Cat, CatFilter, Error, Options,
    Paged,
};

#[rustler::nif]
fn list_cats(options: Options<CatFilter>) -> Result<Paged<Cat>, Error> {
    list_cat(options)
}

#[rustler::nif]
fn list_announcements(options: Options<AnnouncementFilter>) -> Result<Paged<Announcement>, Error> {
    list_announcement(options)
}

rustler::init!("Elixir.Kotkowo.Client", [list_cats, list_announcements]);
