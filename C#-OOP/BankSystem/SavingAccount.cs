using System;

namespace BankSystem
{
    public class SavingAccount : BankAccount
    {
        private decimal _interestRate;

        public decimal InterestRate
        {
            get { return _interestRate; }
            set
            {
                if(value <0)
                    throw new ArgumentException("Interest rate cant be negative");
                _interestRate= value;
            }
        }

        public override string AccountType
        {
            get { return "Savings Account"; }
        }

        public SavingAccount() :base()
        {
            _interestRate= 0;
        }

        public SavingAccount(string fullName, string nationalID, string phoneNumber,string address, decimal balance, decimal interestRate)
            : base(fullName, nationalID,phoneNumber, address, balance)
        {
            InterestRate =interestRate;
        }

        public SavingAccount(string fullName,string nationalID, string phoneNumber, string address, decimal interestRate)
            :base(fullName, nationalID, phoneNumber, address)
        {
            InterestRate= interestRate;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine("Account Type:Saving Account");
            Console.WriteLine("Interest Rate: "+ _interestRate.ToString("P"));
        }

        public override decimal CalculateInterest()
        {
            decimal interest= Balance * _interestRate;
            Console.WriteLine("Interest calculated for Saving Account: "+ interest.ToString("C"));
            return interest;
        }

        public decimal CalculateMonthlyInterest()
        {
            decimal monthlyRate= _interestRate / 12;
            decimal monthlyInterest =Balance * monthlyRate;
            return monthlyInterest;
        }

        public void ApplyMonthlyInterest()
        {
            decimal interest= CalculateMonthlyInterest();
            if (interest> 0)
            {
                Deposit(interest);
                Console.WriteLine($"Monthly interest of {interest:C} applied to account {AccountNumber}");
            }
        }
    }
}
