use kotkowo_client::{
    get_advice_article as _get_advice_article, get_announcement_article, get_cat as get_kitty,
    get_cat_by_slug as get_kitty_by_slug, get_found_cat_by_slug as get_found_kitty_by_slug,
    get_last_view_pull_utc as _get_last_view_pull_utc,
    get_lfh_cat_by_slug as get_lfh_kitty_by_slug, get_lost_cat_by_slug as get_lost_kitty_by_slug,
    list_adopted_cat, list_advice, list_announcement, list_cat, list_external_media as list_media,
    list_found_cat, list_looking_for_adoption_cat, list_lost_cat, update_views_and_last_pull,
    AdoptedCat, Advice, AdviceFilter, Announcement, AnnouncementFilter, Article, BetweenDateTime,
    Cat, CatFilter, Error, ExternalMedia, ExternalMediaFilter, FoundCat, LookingForHomeCat,
    LostCat, Options, Paged, ViewUpdate,
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
fn list_external_media(
    options: Options<ExternalMediaFilter>,
) -> Result<Paged<ExternalMedia>, Error> {
    list_media(options)
}

#[rustler::nif]
fn list_announcements(options: Options<AnnouncementFilter>) -> Result<Paged<Announcement>, Error> {
    list_announcement(options)
}
#[rustler::nif]
fn list_advices(options: Options<AdviceFilter>) -> Result<Paged<Advice>, Error> {
    list_advice(options)
}

#[rustler::nif]
fn get_article(announcement_id: String) -> Result<Article, Error> {
    get_announcement_article(announcement_id)
}
#[rustler::nif]
fn get_advice_article(advice_id: String) -> Result<Article, Error> {
    _get_advice_article(advice_id)
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
fn get_lost_cat_by_slug(cat_slug: String) -> Result<LostCat, Error> {
    get_lost_kitty_by_slug(cat_slug)
}
#[rustler::nif]
fn get_found_cat_by_slug(cat_slug: String) -> Result<FoundCat, Error> {
    get_found_kitty_by_slug(cat_slug)
}
#[rustler::nif]
fn get_lfh_cat_by_slug(cat_slug: String) -> Result<LookingForHomeCat, Error> {
    get_lfh_kitty_by_slug(cat_slug)
}

#[rustler::nif]
fn get_cat(id: String) -> Result<Cat, Error> {
    get_kitty(id)
}

#[rustler::nif]
fn get_last_view_pull_utc() -> Result<String, Error> {
    _get_last_view_pull_utc()
}

#[rustler::nif]
fn update_views(pull_date: String, updates: Vec<ViewUpdate>) -> Result<bool, Error> {
    update_views_and_last_pull(pull_date, updates)
}

rustler::init!(
    "Elixir.Kotkowo.Client",
    [
        list_cats,
        update_views,
        get_last_view_pull_utc,
        list_lost_cats,
        list_found_cats,
        get_cat,
        get_cat_by_slug,
        list_announcements,
        list_advices,
        get_article,
        list_adopted_cats,
        list_looking_for_adoption_cats,
        get_lfh_cat_by_slug,
        get_found_cat_by_slug,
        get_lost_cat_by_slug,
        get_advice_article,
        list_external_media
    ]
);
