use kotkowo_client::{list_cat, Cat, CatFilter, Error, Options, Paged};

#[rustler::nif]
fn list_cats(options: Options<CatFilter>) -> Result<Paged<Cat>, Error> {
    list_cat(options)
}

rustler::init!("Elixir.Kotkowo.Client", [list_cats,]);
