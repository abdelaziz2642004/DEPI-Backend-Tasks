using System;

namespace BankSystem
{
    public interface AccountOperations
    {
        bool Deposit(decimal amount);
        bool Withdraw(decimal amount);
        bool Transfer(BankAccount targetAccount,decimal amount);
    }
}
