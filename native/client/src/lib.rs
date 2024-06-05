use kotkowo_client::{
    get_announcement_article, list_adopted_cat, list_announcement, list_cat, AdoptedCat,
    Announcement, AnnouncementFilter, Article, BetweenDateTime, Cat, CatFilter, Error, Options,
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

#[rustler::nif]
fn get_article(announcement_id: String) -> Result<Article, Error> {
    get_announcement_article(announcement_id)
}

#[rustler::nif]
fn list_adopted_cats(
    options: Options<CatFilter>,
    between_datetime: Option<BetweenDateTime>,
) -> Result<Paged<AdoptedCat>, Error> {
    list_adopted_cat(options, between_datetime)
}

rustler::init!(
    "Elixir.Kotkowo.Client",
    [
        list_cats,
        list_announcements,
        get_article,
        list_adopted_cats
    ]
);
