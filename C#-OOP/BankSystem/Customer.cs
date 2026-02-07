using System;
using System.Collections.Generic;

namespace BankSystem
{
    public class Customer
    {
        private static int _nextCustomerId= 1000;

        public int CustomerId { get; }
        private string _fullName;
        private string _nationalID;
        private DateTime _dateOfBirth;
        private List<BankAccount> _accounts;

        public string FullName
        {
            get { return _fullName; }
            set
            {
                if (string.IsNullOrEmpty(value))
                    throw new ArgumentException("Full name cant be empty");
                _fullName =value;
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if(string.IsNullOrEmpty(value) || value.Length !=14)
                    throw new ArgumentException("National ID must be 14 digits");
                _nationalID= value;
            }
        }

        public DateTime DateOfBirth
        {
            get { return _dateOfBirth; }
            set
            {
                if (value> DateTime.Now)
                    throw new ArgumentException("Date of birth cant be in future");
                _dateOfBirth =value;
            }
        }

        public List<BankAccount> Accounts
        {
            get { return _accounts; }
        }

        public Customer(string fullName,string nationalID, DateTime dateOfBirth)
        {
            CustomerId= _nextCustomerId++;
            FullName =fullName;
            NationalID= nationalID;
            DateOfBirth =dateOfBirth;
            _accounts= new List<BankAccount>();
        }

        public void AddAccount(BankAccount account)
        {
            _accounts.Add(account);
        }

        public bool RemoveAccount(BankAccount account)
        {
            if(account.Balance !=0)
            {
                Console.WriteLine("Cant remove account with non-zero balance");
                return false;
            }
            return _accounts.Remove(account);
        }

        public decimal GetTotalBalance()
        {
            decimal total= 0;
            foreach(var acc in _accounts)
            {
                total +=acc.Balance;
            }
            return total;
        }

        public void UpdateDetails(string newName,DateTime newDob)
        {
            if (!string.IsNullOrEmpty(newName))
                FullName= newName;
            if(newDob != default)
                DateOfBirth= newDob;
        }

        public void DisplayCustomerInfo()
        {
            Console.WriteLine("========== Customer Info ==========");
            Console.WriteLine("Customer ID: "+ CustomerId);
            Console.WriteLine("Name: " +_fullName);
            Console.WriteLine("National ID: "+ _nationalID);
            Console.WriteLine("Date of Birth: " +_dateOfBirth.ToString("yyyy-MM-dd"));
            Console.WriteLine("Number of Accounts: "+ _accounts.Count);
            Console.WriteLine("Total Balance: " +GetTotalBalance().ToString("C"));
            Console.WriteLine("===================================");
        }

        public bool CanBeRemoved()
        {
            foreach (var acc in _accounts)
            {
                if(acc.Balance != 0)
                    return false;
            }
            return true;
        }
    }
}
