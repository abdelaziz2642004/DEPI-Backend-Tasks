using System;

namespace BankSystem
{
    public struct Transaction
    {
        public int TransactionId { get; }
        public string Type { get; }
        public decimal Amount { get; }
        public DateTime Date { get; }
        public string Description { get; }

        private static int _nextId= 1;

        public Transaction(string type, decimal amount,string description)
        {
            TransactionId= _nextId++;
            Type =type;
            Amount= amount;
            Date =DateTime.Now;
            Description= description;
        }

        public override string ToString()
        {
            return $"[{Date:yyyy-MM-dd HH:mm}] {Type}: {Amount:C} - {Description}";
        }

        public static bool operator ==(Transaction left, Transaction right)
        {
            return left.TransactionId== right.TransactionId;
        }

        public static bool operator !=(Transaction left,Transaction right)
        {
            return !(left ==right);
        }

        public override bool Equals(object obj)
        {
            if(obj is Transaction other)
                return this== other;
            return false;
        }

        public override int GetHashCode()
        {
            return TransactionId.GetHashCode();
        }
    }
}
