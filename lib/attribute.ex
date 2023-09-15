defmodule Attribute do
  @callback parse(any()) :: struct()

  def to_string(%_{value: nil}), do: ""
  def to_string(%_{value: text}) when is_binary(text), do: text

  def to_string(%mod{value: other} = self) do
    if function_exported?(mod, :to_string, 1) do
      mod.to_string(self)
    else
      inspect(other)
    end
  end

  defmacro __using__(:string) do
    quote do
      @behaviour Attribute

      defstruct [:value]

      def parse(val) when is_binary(val), do: %__MODULE__{value: val}
      def parse(nil), do: %__MODULE__{value: nil}
      def parse(val), do: %__MODULE__{value: inspect(val)}

      defimpl String.Chars, for: __MODULE__ do
        defdelegate to_string(data), to: Attribute
      end
    end
  end

  defmacro __using__(:integer) do
    quote do
      @behaviour Attribute

      defstruct([:value])

      def parse(val) when is_integer(val), do: %__MODULE__{value: val}
      def parse(val) when is_binary(val), do: %__MODULE__{value: String.to_integer(val)}
      def parse(_), do: %__MODULE__{value: nil}

      defimpl String.Chars, for: __MODULE__ do
        defdelegate to_string(data), to: Attribute
      end
    end
  end

  defmacro __using__(:boolean) do
    quote do
      @behaviour Attribute

      defstruct [:value]

      def parse("true"), do: %__MODULE__{value: true}
      def parse(true), do: %__MODULE__{value: true}
      def parse(_), do: %__MODULE__{value: false}

      defimpl String.Chars, for: __MODULE__ do
        defdelegate to_string(data), to: Attribute
      end
    end
  end

  defmacro __using__(:datetime) do
    quote do
      @behaviour Attribute

      defstruct [:value]

      def parse(val) when is_binary(val) do
        with {:ok, date, _} <- DateTime.from_iso8601(val) do
          %__MODULE__{value: date}
        end
      end

      def parse(_), do: %__MODULE__{value: nil}

      defimpl String.Chars, for: __MODULE__ do
        defdelegate to_string(data), to: Attribute
      end
    end
  end

  defmacro __using__(enum: types) do
    [
      quote do
        @behaviour Attribute

        defstruct [:value]
      end
    ] ++
      Enum.map(types, fn type ->
        quote do
          def parse(unquote("#{type}")), do: %__MODULE__{value: unquote(type)}
        end
      end) ++
      [
        quote do
          def parse(_), do: %__MODULE__{value: nil}

          defimpl String.Chars, for: __MODULE__ do
            defdelegate to_string(data), to: Attribute
          end
        end
      ]
  end
end
