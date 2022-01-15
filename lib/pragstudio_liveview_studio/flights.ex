defmodule PragstudioLiveviewStudio.Flights do
  def search_by_number(number) do
    :timer.sleep(2000)

    list_flights()
    |> Enum.filter(&(&1.number == number))
  end

  def search_by_airport(airport) do
    list_flights()
    |> Enum.filter(&(&1.origin == airport || &1.destination == airport))
  end

  @spec list_flights :: [
          %{
            arrival_time:
              {:error | {any, any, any}, any}
              | {integer, pos_integer, pos_integer}
              | %{
                  :__struct__ => Date | DateTime | NaiveDateTime | Time | Timex.AmbiguousDateTime,
                  optional(:after) => map,
                  optional(:before) => map,
                  optional(:calendar) => atom,
                  optional(:day) => pos_integer,
                  optional(:hour) => non_neg_integer,
                  optional(:microsecond) => {any, any},
                  optional(:minute) => non_neg_integer,
                  optional(:month) => pos_integer,
                  optional(:second) => non_neg_integer,
                  optional(:std_offset) => integer,
                  optional(:time_zone) => binary,
                  optional(:type) => :ambiguous | :gap,
                  optional(:utc_offset) => integer,
                  optional(:year) => integer,
                  optional(:zone_abbr) => binary
                },
            departure_time:
              {:error | {any, any, any}, any}
              | {integer, pos_integer, pos_integer}
              | %{
                  :__struct__ => Date | DateTime | NaiveDateTime | Time | Timex.AmbiguousDateTime,
                  optional(:after) => map,
                  optional(:before) => map,
                  optional(:calendar) => atom,
                  optional(:day) => pos_integer,
                  optional(:hour) => non_neg_integer,
                  optional(:microsecond) => {any, any},
                  optional(:minute) => non_neg_integer,
                  optional(:month) => pos_integer,
                  optional(:second) => non_neg_integer,
                  optional(:std_offset) => integer,
                  optional(:time_zone) => binary,
                  optional(:type) => :ambiguous | :gap,
                  optional(:utc_offset) => integer,
                  optional(:year) => integer,
                  optional(:zone_abbr) => binary
                },
            destination: <<_::24>>,
            number: <<_::24>>,
            origin: <<_::24>>
          },
          ...
        ]
  def list_flights do
    [
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 1),
        arrival_time: Timex.shift(Timex.now(), days: 1, hours: 2)
      },
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 2),
        arrival_time: Timex.shift(Timex.now(), days: 2, hours: 2)
      },
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 3),
        arrival_time: Timex.shift(Timex.now(), days: 3, hours: 2)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 1),
        arrival_time: Timex.shift(Timex.now(), days: 1, hours: 3)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 2),
        arrival_time: Timex.shift(Timex.now(), days: 2, hours: 3)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: Timex.shift(Timex.now(), days: 3),
        arrival_time: Timex.shift(Timex.now(), days: 3, hours: 3)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: Timex.shift(Timex.now(), days: 1),
        arrival_time: Timex.shift(Timex.now(), days: 1, hours: 4)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: Timex.shift(Timex.now(), days: 2),
        arrival_time: Timex.shift(Timex.now(), days: 2, hours: 4)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: Timex.shift(Timex.now(), days: 3),
        arrival_time: Timex.shift(Timex.now(), days: 3, hours: 4)
      }
    ]
  end
end
