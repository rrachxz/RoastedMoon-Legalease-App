const List<Map<String, dynamic>> allScams = [
  {
    'title': 'Fake Rental Agreement Scam',
    'severity': 'high',
    'category': 'Real Estate',
    'description':
    'Scammers pose as landlords, collect deposits, then disappear. Property doesn\'t exist or isn\'t theirs to rent.',
    'redFlags': [
      'Pressure to pay deposit immediately',
      'Can\'t visit property in person',
      'Price too good to be true',
      'Only communicates via email/text',
    ],
    'protect':
    'Always visit property in person. Verify ownership. Never wire money to strangers.',
  },
  {
    'title': 'Employment Contract Fraud',
    'severity': 'high',
    'category': 'Employment',
    'description':
    'Fake job offers requiring upfront payment for training, equipment, or background checks.',
    'redFlags': [
      'Must pay fees before starting',
      'Job offer without interview',
      'Vague job description',
      'Asks for bank account details early',
    ],
    'protect':
    'Legitimate employers never ask for money. Research company thoroughly. Verify job posting.',
  },
  {
    'title': 'Phishing Legal Notices',
    'severity': 'critical',
    'category': 'Cyber Fraud',
    'description':
    'Fake legal documents claiming you owe money or face legal action. Designed to steal personal info.',
    'redFlags': [
      'Urgent threats of legal action',
      'Poor grammar and spelling',
      'Requests payment via gift cards',
      'Unknown sender address',
    ],
    'protect':
    'Verify sender independently. Never click suspicious links. Contact authorities directly.',
  },
  {
    'title': 'Inheritance Scam',
    'severity': 'medium',
    'category': 'Financial',
    'description':
    'Claims you\'ve inherited money from unknown relative. Requires fees to "process" inheritance.',
    'redFlags': [
      'From unknown foreign relative',
      'Large sum of money promised',
      'Requires processing fees',
      'Poor English or grammar',
    ],
    'protect':
    'Real inheritances don\'t require upfront fees. Verify with legitimate legal counsel.',
  },
  {
    'title': 'Fake Loan Agreement',
    'severity': 'high',
    'category': 'Financial',
    'description':
    'Offers guaranteed loans with low rates but requires upfront fees. Loan never materializes.',
    'redFlags': [
      'Guaranteed approval',
      'Upfront fees required',
      'No credit check needed',
      'Pressure to act fast',
    ],
    'protect':
    'Legitimate lenders check credit. Never pay fees before receiving loan. Verify lender license.',
  },
  {
    'title': 'Tech Support Impersonation',
    'severity': 'medium',
    'category': 'Cyber Fraud',
    'description':
    'Fake tech support claims your device has issues, demands payment or remote access.',
    'redFlags': [
      'Unsolicited contact',
      'Claims urgent security threat',
      'Requests remote access',
      'Payment via gift cards',
    ],
    'protect':
    'Tech companies don\'t call unsolicited. Never give remote access. Hang up and verify.',
  },
  {
    'title': 'Charity Donation Fraud',
    'severity': 'low',
    'category': 'Non-Profit',
    'description':
    'Fake charities exploit disasters or causes to collect donations that never reach victims.',
    'redFlags': [
      'Pressure to donate immediately',
      'Vague about how funds used',
      'Can\'t provide tax ID',
      'Only accepts cash or gift cards',
    ],
    'protect':
    'Research charity online. Verify tax-exempt status. Donate through official websites.',
  },
];