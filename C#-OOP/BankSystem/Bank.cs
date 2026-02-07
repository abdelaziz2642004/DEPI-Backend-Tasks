using System;
using System.Collections.Generic;
using System.Linq;

namespace BankSystem
{
    public class Bank
    {
        private string _bankName;
        private string _branchCode;
        private List<Customer> _customers;

        public string BankName
        {
            get { return _bankName; }
        }

        public string BranchCode
        {
            get { return _branchCode; }
        }

        public List<Customer> Customers
        {
            get { return _customers; }
        }

        public Bank(string bankName,string branchCode)
        {
            if (string.IsNullOrEmpty(bankName))
                throw new ArgumentException("Bank name cant be empty");
            if(string.IsNullOrEmpty(branchCode))
                throw new ArgumentException("Branch code cant be empty");

            _bankName= bankName;
            _branchCode =branchCode;
            _customers= new List<Customer>();

            Console.WriteLine($"Bank '{_bankName}' with branch code '{_branchCode}' created successfully");
        }

        public Customer AddCustomer(string fullName, string nationalID,DateTime dateOfBirth)
        {
            foreach(var c in _customers)
            {
                if (c.NationalID== nationalID)
                {
                    Console.WriteLine("Customer with this national ID already exists");
                    return null;
                }
            }

            Customer newCustomer= new Customer(fullName, nationalID, dateOfBirth);
            _customers.Add(newCustomer);
            Console.WriteLine($"Customer '{fullName}' added with ID: {newCustomer.CustomerId}");
            return newCustomer;
        }

        public bool RemoveCustomer(int customerId)
        {
            Customer customer= GetCustomerById(customerId);
            if(customer == null)
            {
                Console.WriteLine("Customer not found");
                return false;
            }

            if (!customer.CanBeRemoved())
            {
                Console.WriteLine("Cant remove customer with accounts that have non-zero balance");
                return false;
            }

            _customers.Remove(customer);
            Console.WriteLine($"Customer {customerId} removed successfully");
            return true;
        }

        public Customer GetCustomerById(int customerId)
        {
            foreach (var c in _customers)
            {
                if(c.CustomerId == customerId)
                    return c;
            }
            return null;
        }

        public List<Customer> SearchCustomersByName(string name)
        {
            List<Customer> results= new List<Customer>();
            foreach(var c in _customers)
            {
                if (c.FullName.ToLower().Contains(name.ToLower()))
                    results.Add(c);
            }
            return results;
        }

        public Customer SearchCustomerByNationalID(string nationalID)
        {
            foreach(var c in _customers)
            {
                if(c.NationalID == nationalID)
                    return c;
            }
            return null;
        }

        public SavingAccount OpenSavingAccount(int customerId, string phoneNumber,string address, decimal initialDeposit, decimal interestRate)
        {
            Customer customer =GetCustomerById(customerId);
            if(customer== null)
            {
                Console.WriteLine("Customer not found");
                return null;
            }

            SavingAccount account= new SavingAccount(customer.FullName, customer.NationalID,phoneNumber, address, initialDeposit,interestRate);
            customer.AddAccount(account);
            Console.WriteLine($"Savings account {account.AccountNumber} opened for customer {customerId}");
            return account;
        }

        public CurrentAccount OpenCurrentAccount(int customerId,string phoneNumber, string address, decimal initialDeposit,decimal overdraftLimit)
        {
            Customer customer= GetCustomerById(customerId);
            if (customer== null)
            {
                Console.WriteLine("Customer not found");
                return null;
            }

            CurrentAccount account =new CurrentAccount(customer.FullName, customer.NationalID, phoneNumber,address, initialDeposit, overdraftLimit);
            customer.AddAccount(account);
            Console.WriteLine($"Current account {account.AccountNumber} opened for customer {customerId}");
            return account;
        }

        public void GenerateBankReport()
        {
            Console.WriteLine("\n============================================================");
            Console.WriteLine($"              BANK REPORT - {_bankName}");
            Console.WriteLine($"              Branch Code: {_branchCode}");
            Console.WriteLine($"              Generated: {DateTime.Now:yyyy-MM-dd HH:mm}");
            Console.WriteLine("============================================================\n");

            Console.WriteLine($"Total Customers: {_customers.Count}");
            Console.WriteLine("------------------------------------------------------------");

            decimal totalBankBalance= 0;
            int totalAccounts =0;

            foreach(var customer in _customers)
            {
                Console.WriteLine($"\nCustomer: {customer.FullName} (ID: {customer.CustomerId})");
                Console.WriteLine($"  National ID: {customer.NationalID}");
                Console.WriteLine($"  Date of Birth: {customer.DateOfBirth:yyyy-MM-dd}");
                Console.WriteLine($"  Number of Accounts: {customer.Accounts.Count}");

                foreach (var account in customer.Accounts)
                {
                    Console.WriteLine($"    - Account {account.AccountNumber} ({account.AccountType}): {account.Balance:C}");
                    totalBankBalance+= account.Balance;
                    totalAccounts++;
                }

                Console.WriteLine($"  Customer Total Balance: {customer.GetTotalBalance():C}");
            }

            Console.WriteLine("\n------------------------------------------------------------");
            Console.WriteLine($"TOTAL ACCOUNTS: {totalAccounts}");
            Console.WriteLine($"TOTAL BANK BALANCE: {totalBankBalance:C}");
            Console.WriteLine("============================================================\n");
        }
    }
}
