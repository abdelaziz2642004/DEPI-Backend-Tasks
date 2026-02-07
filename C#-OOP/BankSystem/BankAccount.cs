using System;
using System.Collections.Generic;

namespace BankSystem
{
    public abstract class BankAccount : AccountOperations
    {
        public const string BankCode= "BNK001";
        public readonly DateTime CreatedDate;

        private static int _nextAccountNumber =10000;

        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;
        private DateTime _dateOpened;
        private List<Transaction> _transactionHistory;

        public int AccountNumber
        {
            get { return _accountNumber; }
        }

        public string FullName
        {
            get { return _fullName; }
            set
            {
                if(string.IsNullOrEmpty(value))
                    throw new ArgumentException("Full name cant be null or empty");
                _fullName= value;
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (!IsValidNationalID(value))
                    throw new ArgumentException("National ID must be exactly 14 digits");
                _nationalID =value;
            }
        }

        public string PhoneNumber
        {
            get { return _phoneNumber; }
            set
            {
                if(!IsValidPhoneNumber(value))
                    throw new ArgumentException("Phone number must start with 01 and be 11 digits");
                _phoneNumber= value;
            }
        }

        public string Address
        {
            get { return _address; }
            set { _address =value; }
        }

        public decimal Balance
        {
            get { return _balance; }
            protected set
            {
                if (value< 0)
                    throw new ArgumentException("Balance must be greater than or equal to 0");
                _balance= value;
            }
        }

        public DateTime DateOpened
        {
            get { return _dateOpened; }
        }

        public List<Transaction> TransactionHistory
        {
            get { return _transactionHistory; }
        }

        public abstract string AccountType { get; }

        protected BankAccount()
        {
            CreatedDate= DateTime.Now;
            _dateOpened= DateTime.Now;
            _accountNumber =_nextAccountNumber++;
            _fullName = "Unknown";
            _nationalID= "00000000000000";
            _phoneNumber ="01000000000";
            _address= "Not Provided";
            _balance =0;
            _transactionHistory= new List<Transaction>();
        }

        protected BankAccount(string fullName, string nationalID,string phoneNumber, string address, decimal balance)
        {
            CreatedDate =DateTime.Now;
            _dateOpened =DateTime.Now;
            _accountNumber= _nextAccountNumber++;
            FullName= fullName;
            NationalID =nationalID;
            PhoneNumber= phoneNumber;
            Address= address;
            Balance =balance;
            _transactionHistory =new List<Transaction>();

            if(balance >0)
            {
                _transactionHistory.Add(new Transaction("DEPOSIT", balance,"Initial deposit"));
            }
        }

        protected BankAccount(string fullName,string nationalID, string phoneNumber, string address)
            :this(fullName, nationalID, phoneNumber,address, 0)
        {
        }

        public virtual void ShowAccountDetails()
        {
            Console.WriteLine("========== Account Details ==========");
            Console.WriteLine("Account Type: " +AccountType);
            Console.WriteLine("Bank Code: " +BankCode);
            Console.WriteLine("Account Number: "+ _accountNumber);
            Console.WriteLine("Full Name: " +_fullName);
            Console.WriteLine("National ID: "+ _nationalID);
            Console.WriteLine("Phone Number: " + _phoneNumber);
            Console.WriteLine("Address: "+_address);
            Console.WriteLine("Balance: " + _balance.ToString("C"));
            Console.WriteLine("Date Opened: "+ _dateOpened.ToString("yyyy-MM-dd"));
            Console.WriteLine("=====================================");
        }

        public bool IsValidNationalID(string nationalID)
        {
            if (string.IsNullOrEmpty(nationalID))
                return false;

            if(nationalID.Length != 14)
                return false;

            foreach (char c in nationalID)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        public bool IsValidPhoneNumber(string phoneNumber)
        {
            if(string.IsNullOrEmpty(phoneNumber))
                return false;

            if (phoneNumber.Length!= 11)
                return false;

            if(!phoneNumber.StartsWith("01"))
                return false;

            foreach(char c in phoneNumber)
            {
                if(!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        public abstract decimal CalculateInterest();

        public virtual bool Deposit(decimal amount)
        {
            if(amount <=0)
            {
                Console.WriteLine("Deposit amount must be positive");
                return false;
            }

            _balance+= amount;
            _transactionHistory.Add(new Transaction("DEPOSIT",amount, "Cash deposit"));
            Console.WriteLine($"Deposited {amount:C} to account {_accountNumber}");
            return true;
        }

        public virtual bool Withdraw(decimal amount)
        {
            if (amount<= 0)
            {
                Console.WriteLine("Withdrawal amount must be positive");
                return false;
            }

            if(amount > _balance)
            {
                Console.WriteLine("Insufficient balance");
                return false;
            }

            _balance -= amount;
            _transactionHistory.Add(new Transaction("WITHDRAWAL", amount,"Cash withdrawal"));
            Console.WriteLine($"Withdrew {amount:C} from account {_accountNumber}");
            return true;
        }

        public virtual bool Transfer(BankAccount targetAccount, decimal amount)
        {
            if(targetAccount == null)
            {
                Console.WriteLine("Target account is invalid");
                return false;
            }

            if (amount<= 0)
            {
                Console.WriteLine("Transfer amount must be positive");
                return false;
            }

            if(amount > _balance)
            {
                Console.WriteLine("Insufficient balance for transfer");
                return false;
            }

            _balance-= amount;
            targetAccount._balance += amount;

            _transactionHistory.Add(new Transaction("TRANSFER_OUT", amount,$"Transfer to account {targetAccount.AccountNumber}"));
            targetAccount._transactionHistory.Add(new Transaction("TRANSFER_IN",amount, $"Transfer from account {_accountNumber}"));

            Console.WriteLine($"Transferred {amount:C} from account {_accountNumber} to account {targetAccount.AccountNumber}");
            return true;
        }

        public void ShowTransactionHistory()
        {
            Console.WriteLine($"\n===== Transaction History for Account {_accountNumber} =====");
            if(_transactionHistory.Count== 0)
            {
                Console.WriteLine("No transactions yet");
            }
            else
            {
                foreach(var transaction in _transactionHistory)
                {
                    Console.WriteLine(transaction.ToString());
                }
            }
            Console.WriteLine("================================================\n");
        }
    }
}
