class TaxClassifcation {
  final Map<String, String> taxReliefClasses = {
    '1': 'Self and dependent relatives.',
    '2': 'Parental medical, dental, special needs, or caretaker expenses.',
    '2b': 'Parental full medical examination.',
    '3':
        'Basic supporting equipment for a DSW-certified disabled self, spouse, child, or parent.',
    '4': 'Individual certified disabled by DSW.',
    '5':
        'Self-education fees for law, accounting, Islamic finance, technical, vocational, industrial, scientific, or technology fields up to degree level.',
    '5b':
        'Self-education fees for any Master\'s or Doctorate level qualification or skill.',
    '5c': 'DSD-recognized up-skilling or self-enhancement courses.',
    '6': 'Medical expenses for serious illness for self, spouse, or child.',
    '6b': 'Fertility treatment expenses for self or spouse.',
    '6c': 'Vaccination expenses for self, spouse, or child.',
    '6d':
        'Dental examination or treatment expenses for self, spouse, or child.',
    '7': 'Complete medical examination for self, spouse, or child.',
    '7b':
        'COVID-19 detection test fees or self-test kit purchases for self, spouse, or child.',
    '7c':
        'Mental health examination or consultation from registered professionals for self, spouse, or child.',
    '8':
        'Assessment expenses for diagnosing specified learning disabilities in a child under 18.',
    '8b':
        'Early intervention programs or rehabilitation treatment for specified learning disabilities in a child under 18.',
    '9':
        'Purchasing books, journals, magazines, or newspapers (non-prohibited).',
    '9b':
        'Purchasing a personal computer, smartphone, or tablet (non-business use).',
    '9c':
        'Monthly internet subscription bills registered under self, spouse, or child.',
    '9d':
        'Self-enrichment course fees (e.g., hobbies, religion, languages, unrelated to job).',
    '10': 'Purchasing sports equipment (as per Sports Development Act 1997).',
    '10b': 'Payment of rental or entrance fees to sports facilities.',
    '10c': 'Registration fees for approved sports competitions.',
    '10d': 'Gym membership or sports training fees by approved providers.',
    '11':
        'Breastfeeding equipment purchase by working mothers for their child up to 2 years old.',
    '12': 'Childcare center or kindergarten fees for a child aged 6 and below.',
    '13': 'Net savings in the National Education Savings Scheme (SSPN/NESS).',
    '14':
        'Spouse (wife, or husband if specific conditions are met) or alimony to a former wife.',
    '15': 'Disabled spouse (wife, or husband if specific conditions are met).',
    '16': 'Unmarried child under 18 years old.',
    '16b_i':
        'Unmarried child 18+ receiving full-time pre-degree instruction (e.g., A-Level, matriculation).',
    '16b_ii':
        'Unmarried child 18+ in full-time recognized higher education (non-pre-degree) in Malaysia, articleship, or degree+ overseas.',
    '16c_i': 'Unmarried child who is physically or mentally disabled.',
    '16c_ii':
        'Unmarried, disabled child 18+ receiving full-time instruction (degree+) in or outside Malaysia at approved institutions.',
    '17':
        'EPF contributions (mandatory/voluntary, non-PRS) or contributions under widow/orphan pension laws.',
    '17b':
        'Life insurance or family Takaful premiums or additional voluntary EPF contributions.',
    '18':
        'Premiums for deferred annuity or contributions to an approved Private Retirement Scheme (PRS).',
    '19':
        'Premiums paid for education or medical benefits insurance that meet specific policy criteria.',
    '20': 'Contributions to Social Security Organization (SOCSO/PERKESO).',
    '21':
        'EV charging facility installation, rental, purchase, or subscription fees for own (non-business) vehicle.'
  };

  /// A map where the key is the classification ID and the value is the relief limit.
  final Map<String, int> reliefLimits = {
    // --- Individual & Dependents ---
    '1': 9000, // Self and dependent relatives
    '2': 8000, // Parental medical expenses (Combines 2 & 2b)

    // --- Disability ---
    '3': 6000, // Basic supporting equipment
    '4': 6000, // Individual certified disabled

    // --- Education ---
    '5':
        7000, // Self-education fees (Combines 5 & 5b: Degree, Master's, Doctorate)
    '5c': 2000, // DSD-recognized up-skilling courses

    // --- Medical ---
    '6': 10000, // Medical expenses (Combines 6, 6b, 6c, 6d, 7, 7b, 7c)
    '8': 4000, // Child learning disability expenses (Combines 8 & 8b)

    // --- Lifestyle ---
    '9':
        2500, // Lifestyle purchases (Combines 9, 9b, 9c: books, gadgets, internet)
    '10': 500, // Sports-related expenses (Combines 10, 10b, 10c, 10d)

    // --- Family & Child ---
    '11': 1000, // Breastfeeding equipment
    '12': 3000, // Childcare or kindergarten fees
    '13': 8000, // National Education Savings Scheme (SSPN)
    '14': 4000, // Spouse or alimony
    '15': 5000, // Disabled spouse
    '16': 2000, // Unmarried child under 18
    '16b_i': 2000, // Unmarried child 18+ (pre-degree)
    '16b_ii': 8000, // Unmarried child 18+ (higher education)
    '16c_i': 6000, // Unmarried disabled child
    '16c_ii': 14000, // Unmarried, disabled child 18+ (higher education)

    // --- Retirement & Insurance ---
    '17': 7000, // EPF and Life Insurance (Combines 17 & 17b)
    '18': 3000, // Private Retirement Scheme (PRS) & Deferred Annuity
    '19': 3000, // Education or medical insurance
    '20': 350, // SOCSO / PERKESO contributions

    // --- Other ---
    '21': 2500, // EV charging facility expenses
  };
}
