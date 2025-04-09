# credo:disable-for-this-file

defmodule BankAccount do
  defmodule Account do
    defstruct balance: 0, state: :open

    def open() do
      %Account{}
    end

    def close(state) do
      %Account{state | state: :closed}
    end

    def balance(%Account{state: :closed}) do
      {:error, :account_closed}
    end

    def balance(%Account{balance: balance}) do
      {:ok, balance}
    end

    def deposit(%Account{state: :closed}, _) do
      {:error, :account_closed}
    end

    def deposit(_, amount) when not is_integer(amount) do
      {:error, :invalid_amount}
    end

    def deposit(_, amount) when amount <= 0 do
      {:error, :amount_must_be_positive}
    end

    def deposit(%Account{balance: balance} = state, amount) do
      {:ok, %Account{state | balance: balance + amount}}
    end

    def withdraw(%Account{state: :closed}, _) do
      {:error, :account_closed}
    end

    def withdraw(_, amount) when not is_integer(amount) do
      {:error, :invalid_amount}
    end

    def withdraw(_, amount) when amount <= 0 do
      {:error, :amount_must_be_positive}
    end

    def withdraw(%Account{balance: balance}, amount) when amount > balance do
      {:error, :not_enough_balance}
    end

    def withdraw(%Account{balance: balance} = state, amount) do
      {:ok, %Account{state | balance: balance - amount}}
    end
  end

  use GenServer

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    pid
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    GenServer.cast(account, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    GenServer.call(account, {:deposit, amount})
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    GenServer.call(account, {:withdraw, amount})
  end

  # Server callbacks

  @impl true
  def init(_keywords) do
    {:ok, %Account{}}
  end

  @impl true
  def handle_cast(:close, state) do
    {:noreply, Account.close(state)}
  end

  @impl true
  def handle_call(:balance, _from, state) do
    case Account.balance(state) do
      {:ok, balance} -> {:reply, balance, state}
      error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    case Account.deposit(state, amount) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state) do
    case Account.withdraw(state, amount) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      error -> {:reply, error, state}
    end
  end
end
