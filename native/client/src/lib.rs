use kotkowo_client::{
    get_announcement_article, get_cat as get_kitty, get_cat_by_slug as get_kitty_by_slug,
    get_lfh_cat_by_slug as get_lfh_kitty_by_slug, list_adopted_cat, list_announcement, list_cat,
    list_found_cat, list_looking_for_adoption_cat, list_lost_cat, AdoptedCat, Announcement,
    AnnouncementFilter, Article, BetweenDateTime, Cat, CatFilter, Error, FoundCat,
    LookingForHomeCat, LostCat, Options, Paged,
};

#[rustler::nif]
fn list_cats(options: Options<CatFilter>) -> Result<Paged<Cat>, Error> {
    list_cat(options)
}
#[rustler::nif]
fn list_lost_cats(options: Options<CatFilter>) -> Result<Paged<LostCat>, Error> {
    list_lost_cat(options)
}
#[rustler::nif]
fn list_found_cats(options: Options<CatFilter>) -> Result<Paged<FoundCat>, Error> {
    list_found_cat(options)
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

#[rustler::nif]
fn list_looking_for_adoption_cats(
    options: Options<CatFilter>,
    owned_by_kotkowo: Option<bool>,
) -> Result<Paged<LookingForHomeCat>, Error> {
    list_looking_for_adoption_cat(options, owned_by_kotkowo)
}

#[rustler::nif]
fn get_cat_by_slug(cat_slug: String) -> Result<Cat, Error> {
    get_kitty_by_slug(cat_slug)
}
#[rustler::nif]
fn get_lfh_cat_by_slug(cat_slug: String) -> Result<LookingForHomeCat, Error> {
    get_lfh_kitty_by_slug(cat_slug)
}

#[rustler::nif]
fn get_cat(id: String) -> Result<Cat, Error> {
    get_kitty(id)
}

rustler::init!(
    "Elixir.Kotkowo.Client",
    [
        list_cats,
        list_lost_cats,
        list_found_cats,
        get_cat,
        get_cat_by_slug,
        list_announcements,
        get_article,
        list_adopted_cats,
        list_looking_for_adoption_cats,
        get_lfh_cat_by_slug
    ]
);
