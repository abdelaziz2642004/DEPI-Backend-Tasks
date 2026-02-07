using System;
using System.Collections.Generic;

namespace BankSystem
{
    class Program
    {
        static void Main(string[] args)
        {

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nSESSION 2\n");
            Console.WriteLine("\n----------------------------------------\n");
            SavingAccount account1= new SavingAccount();
            account1.FullName ="Ahmed Mohamed";
            account1.NationalID= "12345678901234";
            account1.PhoneNumber ="01123456789";
            account1.Address= "Cairo, Egypt";
            account1.Deposit(5000);

            SavingAccount account2 =new SavingAccount("Sara Ali", "98765432109876","01098765432", "Alexandria, Egypt", 10000, 0.03m);

            Console.WriteLine("Account 1 Details:");
            account1.ShowAccountDetails();
            Console.WriteLine();

            Console.WriteLine("Account 2 Details:");
            account2.ShowAccountDetails();
            Console.WriteLine();

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nSESSION 3\n");
            Console.WriteLine("\n----------------------------------------\n");

            SavingAccount savingAcc =new SavingAccount("Mohamed Hassan","11111111111111", "01111111111", "Giza, Egypt",15000, 0.05m);

            CurrentAccount currentAcc= new CurrentAccount("Fatma Ahmed", "22222222222222", "01222222222","Luxor, Egypt", 20000, 5000);

            List<BankAccount> accounts= new List<BankAccount>();
            accounts.Add(savingAcc);
            accounts.Add(currentAcc);

            Console.WriteLine("Looping through all accounts:\n");

            foreach(BankAccount acc in accounts)
            {
                acc.ShowAccountDetails();
                Console.WriteLine();
                acc.CalculateInterest();
                Console.WriteLine("\n----------------------------------------\n");
            }

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nSESSION 4\n");
            Console.WriteLine("\n----------------------------------------\n");




            Bank myBank = new Bank("National Bank of Egypt", "NBE");
            Console.WriteLine();

            Customer customer1= myBank.AddCustomer("Omar Khaled", "30001122334455",new DateTime(1990, 5, 15));
            Customer customer2 =myBank.AddCustomer("Layla Ibrahim", "30002233445566", new DateTime(1985,12, 20));
            Console.WriteLine();

            SavingAccount omarsaving= myBank.OpenSavingAccount(customer1.CustomerId, "01012345678","Cairo, Maadi", 5000, 0.04m);

            CurrentAccount omarcurrent =myBank.OpenCurrentAccount(customer1.CustomerId, "01012345679", "Cairo, Maadi",10000, 2000);

            SavingAccount laylasaving= myBank.OpenSavingAccount(customer2.CustomerId,"01098765432", "Giza, Dokki", 20000,0.05m);
            Console.WriteLine();




            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nACCOUNT OPERATIONS\n");
            Console.WriteLine("\n----------------------------------------\n");


            Console.WriteLine("Depositing money:");
            omarsaving.Deposit(2000);
            Console.WriteLine();

            Console.WriteLine("Withdrawing money:");
            omarcurrent.Withdraw(3000);
            Console.WriteLine();

            Console.WriteLine("Transferring money:");
            omarsaving.Transfer(laylasaving, 1000);
            Console.WriteLine();


            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nTRANSACTION HISTORY\n");
            Console.WriteLine("\n----------------------------------------\n");

            omarsaving.ShowTransactionHistory();
            omarcurrent.ShowTransactionHistory();
            laylasaving.ShowTransactionHistory();


            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nMONTHLY INTEREST CALCULATION\n");
            Console.WriteLine("\n----------------------------------------\n");


            Console.WriteLine($"Monthly interest for Omar's savings: {omarsaving.CalculateMonthlyInterest():C}");
            Console.WriteLine($"Monthly interest for Layla's savings: {laylasaving.CalculateMonthlyInterest():C}");
            Console.WriteLine();

            omarsaving.ApplyMonthlyInterest();
            Console.WriteLine();

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nCUSTOMER SEARCH\n");
            Console.WriteLine("\n----------------------------------------\n");

            Console.WriteLine("Searching for customers with name 'Omar':");
            var searchResults= myBank.SearchCustomersByName("Omar");
            foreach(var c in searchResults)
            {
                c.DisplayCustomerInfo();
            }

            Console.WriteLine("\nSearching by National ID:");
            var foundCustomer =myBank.SearchCustomerByNationalID("30002233445566");
            if(foundCustomer!= null)
            {
                foundCustomer.DisplayCustomerInfo();
            }

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nCUSTOMER TOTAL BALANCE\n");
            Console.WriteLine("\n----------------------------------------\n");




            Console.WriteLine($"Omar's total balance across all accounts: {customer1.GetTotalBalance():C}");
            Console.WriteLine($"Layla's total balance across all accounts: {customer2.GetTotalBalance():C}");

            Console.WriteLine("\n----------------------------------------\n");
            Console.WriteLine("\nBANK REPORT\n");
            Console.WriteLine("\n----------------------------------------\n");

            myBank.GenerateBankReport();

        }
    }
}
