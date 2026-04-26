# credo:disable-for-this-file

defmodule BankAccount do
  defmodule Account do
    defstruct balance: 0, state: :open

    @type state() :: :open | :closed
    @type balance() :: integer()
    @type t() :: %__MODULE__{balance: balance(), state: state()}

    @spec open() :: t()
    def open(), do: %__MODULE__{}

    @spec close(t()) :: t()
    def close(account), do: %{account | state: :closed}

    @spec balance(t()) :: {:ok, balance()} | {:error, atom()}
    def balance(%{state: :closed}), do: {:error, :account_closed}
    def balance(%{balance: balance}), do: {:ok, balance}

    @spec deposit(t(), integer()) :: {:ok, t()} | {:error, atom()}
    def deposit(%{state: :closed}, _), do: {:error, :account_closed}
    def deposit(_, amount) when not is_integer(amount), do: {:error, :invalid_amount}
    def deposit(_, amount) when amount <= 0, do: {:error, :amount_must_be_positive}
    def deposit(%{balance: balance} = a, amount), do: {:ok, %{a | balance: balance + amount}}

    @spec withdraw(t(), integer()) :: {:ok, t()} | {:error, atom()}
    def withdraw(%{state: :closed}, _), do: {:error, :account_closed}
    def withdraw(_, amount) when not is_integer(amount), do: {:error, :invalid_amount}
    def withdraw(_, amount) when amount <= 0, do: {:error, :amount_must_be_positive}

    def withdraw(%{balance: balance}, amount) when amount > balance,
      do: {:error, :not_enough_balance}

    def withdraw(%{balance: balance} = a, amount), do: {:ok, %{a | balance: balance - amount}}
  end

  use GenServer

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account() :: pid()

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account()
  def open() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    pid
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account()) :: :ok
  def close(account), do: GenServer.cast(account, :close)

  @doc """
  Get the account's balance.
  """
  @spec balance(account()) :: integer() | {:error, :account_closed}
  def balance(account), do: GenServer.call(account, :balance)

  @doc """
  Add the given amount to the account's balance.
  """
  @type deposit_error() :: :account_closed | :amount_must_be_positive
  @spec deposit(account(), integer()) :: :ok | {:error, deposit_error()}
  def deposit(account, amount), do: GenServer.call(account, {:deposit, amount})

  @doc """
  Subtract the given amount from the account's balance.
  """
  @type withdraw_error() :: :account_closed | :amount_must_be_positive | :not_enough_balance
  @spec withdraw(account(), integer()) :: :ok | {:error, withdraw_error()}
  def withdraw(account, amount), do: GenServer.call(account, {:withdraw, amount})

  # Server callbacks

  @impl true
  def init(_), do: {:ok, Account.open()}

  @impl true
  def handle_call(:balance, _from, state) do
    case Account.balance(state) do
      {:ok, balance} -> {:reply, balance, state}
      {:error, _} = error -> {:reply, error, state}
    end
  end

  def handle_call({:deposit, amount}, _from, state) do
    case Account.deposit(state, amount) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      {:error, _} = error -> {:reply, error, state}
    end
  end

  def handle_call({:withdraw, amount}, _from, state) do
    case Account.withdraw(state, amount) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      {:error, _} = error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_cast(:close, state), do: {:noreply, Account.close(state)}
end
