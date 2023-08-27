use chrono::{Datelike, Timelike};
use derivative::Derivative;
use rustler::{Atom, Decoder, Encoder, NifStruct};
use serde::Deserialize;

mod elixir_module_atoms {
    rustler::atoms! {
        calendar_iso = "Elixir.Calendar.ISO"
    }
}

#[derive(Debug, NifStruct, Derivative)]
#[derivative(Default)]
#[module = "DateTime"]
pub struct ElixirDateTime {
    #[derivative(Default(value = "self::elixir_module_atoms::calendar_iso()"))]
    calendar: Atom,
    day: usize,
    hour: usize,
    microsecond: (usize, usize),
    minute: usize,
    month: usize,
    second: usize,
    std_offset: usize,
    #[derivative(Default(value = "\"Etc/UTC\".into()"))]
    time_zone: String,
    utc_offset: usize,
    year: usize,
    #[derivative(Default(value = "\"UTC\".into()"))]
    zone_abbr: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct DateTime(chrono::DateTime<chrono::Utc>);

impl From<DateTime> for ElixirDateTime {
    fn from(value: DateTime) -> Self {
        ElixirDateTime {
            year: value.0.year() as usize,
            month: value.0.month() as usize,
            day: value.0.day() as usize,
            hour: value.0.hour() as usize,
            minute: value.0.minute() as usize,
            second: value.0.second() as usize,
            ..Default::default()
        }
    }
}

impl Decoder<'_> for DateTime {
    fn decode<'a>(_term: rustler::Term<'a>) -> rustler::NifResult<Self> {
        todo!()
    }
}

impl Encoder for DateTime {
    fn encode<'a>(&self, env: rustler::Env<'a>) -> rustler::Term<'a> {
        let elixir_dt: ElixirDateTime = (*self).clone().into();
        elixir_dt.encode(env)
    }
}
