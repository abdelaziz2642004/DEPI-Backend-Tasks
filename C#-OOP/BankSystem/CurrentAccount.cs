using System;

namespace BankSystem
{
    public class CurrentAccount :BankAccount
    {
        private decimal _overdraftLimit;

        public decimal OverdraftLimit
        {
            get { return _overdraftLimit; }
            set
            {
                if (value< 0)
                    throw new ArgumentException("Overdraft limit cant be negative");
                _overdraftLimit =value;
            }
        }

        public override string AccountType
        {
            get { return "Current Account"; }
        }

        public CurrentAccount(): base()
        {
            _overdraftLimit =0;
        }

        public CurrentAccount(string fullName, string nationalID,string phoneNumber, string address,decimal balance, decimal overdraftLimit)
            :base(fullName, nationalID, phoneNumber, address,balance)
        {
            OverdraftLimit= overdraftLimit;
        }

        public CurrentAccount(string fullName, string nationalID, string phoneNumber,string address, decimal overdraftLimit)
            : base(fullName,nationalID, phoneNumber, address)
        {
            OverdraftLimit =overdraftLimit;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine("Account Type: Current Account");
            Console.WriteLine("Overdraft Limit: "+ _overdraftLimit.ToString("C"));
        }

        public override decimal CalculateInterest()
        {
            Console.WriteLine("Current Accounts do not earn interest");
            return 0;
        }
    }
}
