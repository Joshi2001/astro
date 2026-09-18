class QuestionnaireField {
  final String key;
  final String category;
  final String question;
  final List<String> options;

  const QuestionnaireField({
    required this.key,
    required this.category,
    required this.question,
    required this.options,
  });
}

class QuestionnaireMeta {
  QuestionnaireMeta._();

  static const List<String> categories = [
    'Personality',
    'Emotions & Support',
    'Communication',
    'Trust & Commitment',
    'Lifestyle & Routine',
    'Career & Money',
    'Family',
    'Relationship Vision',
  ];

  static const List<QuestionnaireField> fields = [
    QuestionnaireField(
      key: 'decisionMaking',
      category: 'Personality',
      question: 'When deciding something important, you tend to…',
      options: [
        'Weigh options carefully with logic',
        'Go with your heart and intuition',
        'Ask trusted people for advice',
        'Decide fast and adjust later',
      ],
    ),
    QuestionnaireField(
      key: 'socialNature',
      category: 'Personality',
      question: 'In social settings you feel most comfortable…',
      options: [
        'In the middle of the action',
        'In smaller, close-knit groups',
        'Observing quietly first',
        'Only with people you already know',
      ],
    ),
    QuestionnaireField(
      key: 'changeVsStability',
      category: 'Personality',
      question: 'New routines and sudden changes make you feel…',
      options: [
        'Excited — variety keeps life interesting',
        'Okay, if they are planned',
        'Nervous and a bit unsettled',
        'Relieved — I love breaking monotony',
      ],
    ),
    QuestionnaireField(
      key: 'emotionalHandling',
      category: 'Emotions & Support',
      question: 'When you feel emotional, you usually…',
      options: [
        'Share it openly with someone close',
        'Process it quietly on your own',
        'Need time before talking about it',
        'Use humour or distraction to cope',
      ],
    ),
    QuestionnaireField(
      key: 'emotionalSupport',
      category: 'Emotions & Support',
      question: 'The support you value most from a partner is…',
      options: [
        'Listening without trying to fix things',
        'Practical help and clear actions',
        'Words of encouragement',
        'Just being present and calm',
      ],
    ),
    QuestionnaireField(
      key: 'stressResponse',
      category: 'Emotions & Support',
      question: 'Under stress, your go-to behaviour is…',
      options: [
        'Tackle the problem head-on',
        'Step back and breathe first',
        'Talk it out with someone',
        'Keep busy to distract yourself',
      ],
    ),
    QuestionnaireField(
      key: 'disagreementStyle',
      category: 'Communication',
      question: 'During a disagreement you prefer to…',
      options: [
        'Address it immediately and calmly',
        'Wait until emotions cool down',
        'Express feelings honestly, then listen',
        'Avoid conflict where possible',
      ],
    ),
    QuestionnaireField(
      key: 'communicationImportance',
      category: 'Communication',
      question: 'For you, good communication in a relationship means…',
      options: [
        'Frequent, open conversations',
        'Clear and honest even when tough',
        'Quality talks over quantity',
        'Actions speaking louder than words',
      ],
    ),
    QuestionnaireField(
      key: 'problemSolving',
      category: 'Communication',
      question: 'When solving a shared problem you would rather…',
      options: [
        'Brainstorm together and decide as a team',
        'Take the lead and find a solution',
        'Consider every option before moving',
        'Trust your partner\u2019s judgement',
      ],
    ),
    QuestionnaireField(
      key: 'trustBuilding',
      category: 'Trust & Commitment',
      question: 'Trust develops fastest for you through…',
      options: [
        'Time and consistent behaviour',
        'Open and transparent sharing',
        'Seeing them keep their promises',
        'Shared experiences together',
      ],
    ),
    QuestionnaireField(
      key: 'honesty',
      category: 'Trust & Commitment',
      question: 'In a relationship, honesty matters most when…',
      options: [
        'Always, even about small things',
        'About important matters',
        'It is kind and well-timed',
        'They ask directly',
      ],
    ),
    QuestionnaireField(
      key: 'commitment',
      category: 'Trust & Commitment',
      question: 'You see commitment as…',
      options: [
        'A promise you work on daily',
        'Choosing each other every day',
        'A natural milestone of love',
        'Something proven over years',
      ],
    ),
    QuestionnaireField(
      key: 'responsibility',
      category: 'Trust & Commitment',
      question: 'When a task needs to be done, you usually…',
      options: [
        'Take it on and finish it yourself',
        'Split it fairly and share the load',
        'Check who\u2019s good at it first',
        'Rally everyone together',
      ],
    ),
    QuestionnaireField(
      key: 'decisionHandling',
      category: 'Trust & Commitment',
      question: 'Big joint decisions (home, finances, career moves)…',
      options: [
        'We decide together, always',
        'I prefer one person to take the lead',
        'We talk until we fully agree',
        'We go with the most practical option',
      ],
    ),
    QuestionnaireField(
      key: 'conflictResolution',
      category: 'Communication',
      question: 'After an argument, you usually…',
      options: [
        'Resolve it and move on quickly',
        'Need a little space first',
        'Revisit it calmly to learn',
        'Drop it and carry on',
      ],
    ),
    QuestionnaireField(
      key: 'familyImportance',
      category: 'Family',
      question: 'How central are family relationships to your life?',
      options: [
        'Core — family comes first',
        'Important, with clear boundaries',
        'Supportive but independent',
        'My chosen circle is my family',
      ],
    ),
    QuestionnaireField(
      key: 'familyInvolvement',
      category: 'Family',
      question:
          'You would prefer your partner\u2019s family involvement to be…',
      options: [
        'Close and regular',
        'Warm but at a healthy distance',
        'On special occasions',
        'Minimal — just us',
      ],
    ),
    QuestionnaireField(
      key: 'socialLifestyle',
      category: 'Lifestyle & Routine',
      question: 'Evenings out, hosting and a lively circle are…',
      options: [
        'My happy place',
        'Fun in moderation',
        'Nice occasionally',
        'Not really my thing',
      ],
    ),
    QuestionnaireField(
      key: 'travelPreferences',
      category: 'Lifestyle & Routine',
      question: 'Your ideal kind of travel is…',
      options: [
        'Spontaneous adventures',
        'Carefully planned trips',
        'Weekend getaways nearby',
        'Relaxed, slow travel',
      ],
    ),
    QuestionnaireField(
      key: 'dailyRoutine',
      category: 'Lifestyle & Routine',
      question: 'Your daily routine can best be described as…',
      options: [
        'Structured and predictable',
        'Flexible and changeable',
        'Busy and on-the-go',
        'Easy-going and relaxed',
      ],
    ),
    QuestionnaireField(
      key: 'careerPriority',
      category: 'Career & Money',
      question: 'When it comes to career ambition, you…',
      options: [
        'Pursue growth and goals fiercely',
        'Value work-life balance highly',
        'Grow steadily without rush',
        'Prioritise passion over pay',
      ],
    ),
    QuestionnaireField(
      key: 'financialApproach',
      category: 'Career & Money',
      question: 'Your approach to money is…',
      options: [
        'Save first, spend later',
        'Spend consciously on what matters',
        'Plan budgets and track closely',
        'Manage it as it comes',
      ],
    ),
    QuestionnaireField(
      key: 'careerAfterMarriage',
      category: 'Career & Money',
      question: 'Post-marriage, careers should ideally…',
      options: [
        'Both continue fully',
        'Flex around family needs',
        'One partner may lead at times',
        'Completely depend on circumstances',
      ],
    ),
    QuestionnaireField(
      key: 'idealRelationship',
      category: 'Relationship Vision',
      question: 'Your ideal relationship looks most like…',
      options: [
        'Two best friends who grow together',
        'A romantic team taking on the world',
        'A calm, nurturing safe space',
        'Passion and adventure together',
      ],
    ),
    QuestionnaireField(
      key: 'personalSpace',
      category: 'Relationship Vision',
      question: 'Personal space in a relationship should be…',
      options: [
        'Valued and protected',
        'Flexible depending on the week',
        'Always together — space is unlikely',
        'Defined early and respected',
      ],
    ),
    QuestionnaireField(
      key: 'longTermGoals',
      category: 'Relationship Vision',
      question: 'Looking 10 years ahead, you picture…',
      options: [
        'A family and a shared home',
        'Growing careers side by side',
        'Exploring the world together',
        'Whatever life unfolds, together',
      ],
    ),
  ];
}
