using System;

namespace BankSystem
// for main
{
    public static class BankUtilities
    {
        public static bool ValidateNationalID(string nationalID)
        {
            if (string.IsNullOrEmpty(nationalID))
                return false;

            if (nationalID.Length != 14)
                return false;

            foreach (char c in nationalID)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        public static bool ValidatePhoneNumber(string phoneNumber)
        {
            if (string.IsNullOrEmpty(phoneNumber))
                return false;

            if (phoneNumber.Length != 11)
                return false;

            if (!phoneNumber.StartsWith("01"))
                return false;

            foreach (char c in phoneNumber)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        public static int CalculateAge(DateTime dateOfBirth)
        {
            DateTime today = DateTime.Today;
            int age = today.Year - dateOfBirth.Year;

            if (dateOfBirth.Date > today.AddYears(-age))
                age--;

            return age;
        }

        public static void PrintSeparator()
        {
            Console.WriteLine("============================================");
        }

   
    }
}
