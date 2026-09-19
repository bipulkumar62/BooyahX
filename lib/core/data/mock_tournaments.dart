import 'package:booyahx/core/models/tournament.dart';

/// BooyahX — Mock Tournament Data
///
/// Realistic tournament data inspired by the Stitch design.
/// Used for Home screen rendering during development.
/// Will be replaced by a real API data source later.
class MockTournamentData {
  MockTournamentData._();

  // ── Featured Banner Tournament ──
  static const Tournament featuredBanner = Tournament(
    id: 'featured-elite-cup',
    name: 'FREE FIRE MAX ELITE CUP',
    description: 'Grand Pool • Top 100 Players',
    mode: 'SOLO BR',
    map: 'Bermuda',
    dateTime: 'Today, 08:00 PM IST',
    status: TournamentStatus.closingSoon,
    statusLabel: 'Closing Soon',
    prizePool: '₹50,000',
    entryFee: '₹100',
    totalSlots: 100,
    filledSlots: 94,
    isFeatured: true,
    featuredPrizePool: '₹50,000',
    featuredTimeLeft: '2h 15m left',
    featuredJoinedCount: 94,
    featuredTotalCount: 100,
    category: TournamentCategory.soloBr,
  );

  // ── All Tournaments ──
  static final List<Tournament> tournaments = [
    // ── SOLO BR ──
    const Tournament(
      id: 'br-001',
      name: 'FREE FIRE - OLD THUNDER',
      description: 'Custom Room BR Ranked Mode • Official Anti-Cheat Verified',
      mode: 'SOLO BR',
      map: 'Bermuda',
      dateTime: 'Today, 08:30 PM IST',
      status: TournamentStatus.registrationOpen,
      statusLabel: 'Registration Open',
      prizePool: '₹10,000',
      perKill: '₹25',
      entryFee: '₹50',
      totalSlots: 100,
      filledSlots: 76,
      category: TournamentCategory.soloBr,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
    ),
    const Tournament(
      id: 'br-002',
      name: 'FF - SOLO RAMPAGE',
      description: 'High Stakes Solo Battle Royale • Kill Points Bonus',
      mode: 'SOLO BR',
      map: 'Bermuda',
      dateTime: 'Today, 09:00 PM IST',
      status: TournamentStatus.almostFull,
      statusLabel: 'Almost Full',
      prizePool: '₹8,000',
      perKill: '₹20',
      entryFee: '₹40',
      totalSlots: 48,
      filledSlots: 42,
      category: TournamentCategory.soloBr,
    ),
    const Tournament(
      id: 'br-003',
      name: 'FREE FIRE - SOLO HUNTER',
      description: 'Aggressive Playstyle Rewards • Top Frag Bonus',
      mode: 'SOLO BR',
      map: 'Kalahari',
      dateTime: 'Tomorrow, 05:00 PM IST',
      status: TournamentStatus.open,
      statusLabel: 'Open',
      prizePool: '₹6,000',
      perKill: '₹15',
      entryFee: '₹30',
      totalSlots: 48,
      filledSlots: 20,
      category: TournamentCategory.soloBr,
    ),
    const Tournament(
      id: 'br-004',
      name: 'BERMUDA CHAMPIONSHIP #104',
      description: 'Custom Room BR Ranked Mode • Official Anti-Cheat Verified',
      mode: 'SOLO BR',
      map: 'Bermuda',
      dateTime: 'Today, 08:30 PM IST',
      status: TournamentStatus.registrationOpen,
      statusLabel: 'Registration Open',
      prizePool: '₹10,000',
      perKill: '₹25',
      entryFee: '₹50',
      totalSlots: 100,
      filledSlots: 76,
      category: TournamentCategory.soloBr,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvt8LxaOaJEGut5AH5GdcYvAQPhFd4aywrRQ6thy47c1Bjdz16BIHblnLK_W03drfWJ0Lto0Iua96RmWzvSBbE-hNT52dP8Lg7ziU97Ux-VLicjFCwU3AOkI3Z6Pxc2Vn_ua_M5FhEEQCEvrSM90GGFlX732SO9-p4Sw8wY04QkMzMEL76_EftVP9_XFgn_UWGoYTqobxnLrJRpfjksYesWWcW81Q8m8ohoYcdOUZOTv5TvqzCyV5U',
    ),

    // ── DUO BR ──
    const Tournament(
      id: 'duo-001',
      name: 'KALAHARI BLITZ SURVIVAL',
      description: '2 Players Squad Duo • Match ID Shared 15m Prior',
      mode: 'DUO BR',
      map: 'Kalahari',
      dateTime: 'Tomorrow, 04:00 PM IST',
      status: TournamentStatus.open,
      statusLabel: 'Open',
      prizePool: '₹15,000',
      perKill: '₹30',
      entryFee: '₹80',
      totalSlots: 25,
      filledSlots: 18,
      category: TournamentCategory.duoBr,
      ctaLabel: 'Register Duo',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDG0wJCH-_WOmhLS_pg8eGmzHkGwCwva_c0V3MFx7hd3aCnVoL2NpRC0vUV3iro8ST8QkEW8ObaW4CIpJ5oqevC2x74sHs3lVDZdXWEnZA1KucB0-aZuDx8BksI8desmengPVAYqkKYy7dbhU_Dfbfgbhmjvb064BMo5O1ZaC58YRUPJiVSa59Sw2jhv0NygE5x_D0yzG-hBfKRrF4QlwqlCalHt6dwBS7z3xFHZ7HBvEkIyS2LXazs',
    ),
    const Tournament(
      id: 'duo-002',
      name: 'DUO SHOWDOWN ARENA',
      description: 'Partner Duos Only • Rank Requirement: Platinum+',
      mode: 'DUO BR',
      map: 'Bermuda',
      dateTime: 'Tomorrow, 07:30 PM IST',
      status: TournamentStatus.registrationOpen,
      statusLabel: 'Registration Open',
      prizePool: '₹12,000',
      perKill: '₹35',
      entryFee: '₹70',
      totalSlots: 25,
      filledSlots: 14,
      category: TournamentCategory.duoBr,
      ctaLabel: 'Register Duo',
    ),

    // ── SOLO PER KILL ──
    const Tournament(
      id: 'kill-001',
      name: 'PURGATORY KILL RUSH #88',
      description: 'High Kill Bonus • Level 40+ Profile Requirement',
      mode: 'SOLO PER KILL',
      map: 'Purgatory',
      dateTime: 'Today, 09:15 PM IST',
      status: TournamentStatus.almostFull,
      statusLabel: 'Almost Full',
      prizePool: '₹5,000',
      perKill: '₹40',
      entryFee: '₹30',
      totalSlots: 48,
      filledSlots: 42,
      category: TournamentCategory.soloPerKill,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB8TuY8g-iIobdUwIuG1PRqYhBk8Y4AP3DlbbTRQ7JSS5JIchqfwDAgMbeBFMPQUbQiH1x9ozu0ALmQbOSVpp-J1FeQhJ0A4pckRhKI-1kS0aVT5G_5VPrgNeDsEeIybhKfz9qDLhfyV_-mi8ZJSg-CAPUiPDAHvnoNb68YBVKWHZsTmBgAMd5XtpZ21JyD93HX_F6dse7CI3_7wyNp7qNo1mMFwc255GSJj8V9mtPQOeGP9BlCrLDp',
    ),
    const Tournament(
      id: 'kill-002',
      name: 'SOLO SLAYER ARENA',
      description: 'Per Kill Rewards • No Entry Fee Cap',
      mode: 'SOLO PER KILL',
      map: 'Bermuda',
      dateTime: 'Tomorrow, 06:00 PM IST',
      status: TournamentStatus.open,
      statusLabel: 'Open',
      prizePool: '₹4,000',
      perKill: '₹35',
      entryFee: '₹25',
      totalSlots: 48,
      filledSlots: 15,
      category: TournamentCategory.soloPerKill,
    ),

    // ── DUO PER KILL ──
    const Tournament(
      id: 'dpk-001',
      name: 'DUO KILL FRENZY',
      description: 'Partner Duo Per Kill • Split Rewards',
      mode: 'DUO PER KILL',
      map: 'Purgatory',
      dateTime: 'Tomorrow, 08:00 PM IST',
      status: TournamentStatus.open,
      statusLabel: 'Open',
      prizePool: '₹8,000',
      perKill: '₹50',
      entryFee: '₹60',
      totalSlots: 25,
      filledSlots: 10,
      category: TournamentCategory.duoPerKill,
      ctaLabel: 'Register Duo',
    ),
  ];

  // ── Tournament Detail Data ──

  static final List<TournamentDetail> _details = [
    // ── br-001: FREE FIRE - OLD THUNDER ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'br-001'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹25',
      killBountyLabel: 'Kill Bounty Assurance',
      killBountyAmount: '₹25',
      killBountyDescription:
          '₹25 credited per verified kill to your BooyahX wallet within 30 mins after match conclusion and anti-cheat validation.',
      prizeDistribution: const [
        PrizeDistribution(
          rank: 1,
          title: 'Champion',
          subtitle: 'Winner Trophy + Title',
          amount: '₹3,500',
          percentage: '35% of pool',
          isHighlighted: true,
        ),
        PrizeDistribution(
          rank: 2,
          title: 'Runner Up',
          subtitle: 'Silver Tier',
          amount: '₹2,000',
          percentage: '20% of pool',
        ),
        PrizeDistribution(
          rank: 3,
          title: '2nd Runner Up',
          subtitle: 'Bronze Tier',
          amount: '₹1,200',
          percentage: '12% of pool',
        ),
        PrizeDistribution(
          rankRange: '#4 - #5',
          title: 'Semi-Finalists',
          subtitle: 'Top 5 Survival',
          amount: '₹600',
          amountEach: '₹600 each',
          percentage: 'Total: ₹1,200',
        ),
        PrizeDistribution(
          rankRange: '#6 - #10',
          title: 'Top Ten Finishers',
          subtitle: 'Placement Cashout',
          amount: '₹250',
          amountEach: '₹250 each',
          percentage: 'Total: ₹1,250',
        ),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'Xenon_Striker', uid: '849301294', level: 72, slotLabel: 'SLOT 01'),
        TournamentPlayer(rank: 2, name: 'Hydra_NinjaFF', uid: '190483726', level: 68, slotLabel: 'SLOT 02'),
        TournamentPlayer(rank: 3, name: 'Viper_Ares', uid: '938210384', level: 65, slotLabel: 'SLOT 03'),
        TournamentPlayer(rank: 4, name: 'Titan_Ghost', uid: '758291046', level: 63, slotLabel: 'SLOT 04'),
        TournamentPlayer(rank: 5, name: 'ShadowBlade_FF', uid: '627384910', level: 61, slotLabel: 'SLOT 05'),
        TournamentPlayer(rank: 6, name: 'Phoenix_Rider', uid: '518273640', level: 59, slotLabel: 'SLOT 06'),
        TournamentPlayer(rank: 7, name: 'StormBreaker', uid: '409182736', level: 57, slotLabel: 'SLOT 07'),
        TournamentPlayer(rank: 8, name: 'Ace_ShadowX', uid: '389271645', level: 55, slotLabel: 'SLOT 08'),
      ],
      rules: const [
        TournamentRule(
          number: 1,
          title: 'Room ID & Password',
          description:
              'Credentials will be revealed 15 minutes prior to match launch directly in this app. Ensure you join on your registered in-game account.',
        ),
        TournamentRule(
          number: 2,
          title: 'Fair Play & Anti-Cheat',
          description:
              'Teaming, emulator usage without notice, or 3rd-party script injections lead to an immediate ban and forfeiture of all prizes.',
        ),
        TournamentRule(
          number: 3,
          title: 'Screenshot Verification',
          description:
              'Take a victory screenshot showing your rank and total kills immediately upon match conclusion for payout audits.',
        ),
        TournamentRule(
          number: 4,
          title: 'Screen Recording',
          description:
              'Full match screen recording is mandatory for all participants. Recordings must be uploaded within 30 minutes of match end.',
        ),
        TournamentRule(
          number: 5,
          title: 'No Teaming',
          description:
              'Any form of collaboration between solo players is strictly prohibited and will result in immediate disqualification.',
        ),
        TournamentRule(
          number: 6,
          title: 'Mobile Only',
          description:
              'Only mobile devices are permitted. Emulators, tablets, and iPad are not allowed unless explicitly stated in tournament rules.',
        ),
        TournamentRule(
          number: 7,
          title: 'Minimum Level',
          description:
              'Players must have a minimum profile level of 40 to participate in this tournament.',
        ),
        TournamentRule(
          number: 8,
          title: 'POV Requirement',
          description:
              'Top 3 finishers must submit their full match POV recording for verification and content purposes.',
        ),
        TournamentRule(
          number: 9,
          title: 'POV Submission',
          description:
              'Upload your POV recording via the Room Details screen within 30 minutes of match completion.',
        ),
        TournamentRule(
          number: 10,
          title: 'Missed Room Policy',
          description:
              'Players who fail to join the room within 5 minutes of the scheduled start will be forfeited with no refund.',
        ),
        TournamentRule(
          number: 11,
          title: 'Suspension & Refund Policy',
          description:
              'Disqualified players may face a temporary suspension from future tournaments. Entry fees are non-refundable after room generation.',
        ),
        TournamentRule(
          number: 12,
          title: 'Hacking & Panels',
          description:
              'Use of any hacks, mods, or panel apps results in a permanent ban from BooyahX and forfeiture of all winnings.',
        ),
        TournamentRule(
          number: 13,
          title: 'Result Declaration',
          description:
              'Final results are declared within 60 minutes after match completion, pending anti-cheat validation and score reconciliation.',
        ),
      ],
    ),

    // ── br-004: BERMUDA CHAMPIONSHIP #104 ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'br-004'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹25',
      killBountyLabel: 'Kill Bounty Assurance',
      killBountyAmount: '₹25',
      killBountyDescription:
          '₹25 credited per verified kill to your BooyahX wallet within 30 mins after match conclusion and anti-cheat validation.',
      prizeDistribution: const [
        PrizeDistribution(
          rank: 1,
          title: 'Champion',
          subtitle: 'Winner Trophy + Title',
          amount: '₹3,500',
          percentage: '35% of pool',
          isHighlighted: true,
        ),
        PrizeDistribution(
          rank: 2,
          title: 'Runner Up',
          subtitle: 'Silver Tier',
          amount: '₹2,000',
          percentage: '20% of pool',
        ),
        PrizeDistribution(
          rank: 3,
          title: '2nd Runner Up',
          subtitle: 'Bronze Tier',
          amount: '₹1,200',
          percentage: '12% of pool',
        ),
        PrizeDistribution(
          rankRange: '#4 - #5',
          title: 'Semi-Finalists',
          subtitle: 'Top 5 Survival',
          amount: '₹600',
          amountEach: '₹600 each',
          percentage: 'Total: ₹1,200',
        ),
        PrizeDistribution(
          rankRange: '#6 - #10',
          title: 'Top Ten Finishers',
          subtitle: 'Placement Cashout',
          amount: '₹250',
          amountEach: '₹250 each',
          percentage: 'Total: ₹1,250',
        ),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'Xenon_Striker', uid: '849301294', level: 72, slotLabel: 'SLOT 01'),
        TournamentPlayer(rank: 2, name: 'Hydra_NinjaFF', uid: '190483726', level: 68, slotLabel: 'SLOT 02'),
        TournamentPlayer(rank: 3, name: 'Viper_Ares', uid: '938210384', level: 65, slotLabel: 'SLOT 03'),
        TournamentPlayer(rank: 4, name: 'Titan_Ghost', uid: '758291046', level: 63, slotLabel: 'SLOT 04'),
        TournamentPlayer(rank: 5, name: 'ShadowBlade_FF', uid: '627384910', level: 61, slotLabel: 'SLOT 05'),
        TournamentPlayer(rank: 6, name: 'Phoenix_Rider', uid: '518273640', level: 59, slotLabel: 'SLOT 06'),
        TournamentPlayer(rank: 7, name: 'StormBreaker', uid: '409182736', level: 57, slotLabel: 'SLOT 07'),
        TournamentPlayer(rank: 8, name: 'Ace_ShadowX', uid: '389271645', level: 55, slotLabel: 'SLOT 08'),
        TournamentPlayer(rank: 9, name: 'BlazeFist99', uid: '278364510', level: 53, slotLabel: 'SLOT 09'),
        TournamentPlayer(rank: 10, name: 'RazorEdge_FF', uid: '167253409', level: 51, slotLabel: 'SLOT 10'),
      ],
      rules: const [
        TournamentRule(
          number: 1,
          title: 'Room ID & Password',
          description:
              'Credentials will be revealed 15 minutes prior to match launch directly in this app. Ensure you join on your registered in-game account.',
        ),
        TournamentRule(
          number: 2,
          title: 'Fair Play & Anti-Cheat',
          description:
              'Teaming, emulator usage without notice, or 3rd-party script injections lead to an immediate ban and forfeiture of all prizes.',
        ),
        TournamentRule(
          number: 3,
          title: 'Screenshot Verification',
          description:
              'Take a victory screenshot showing your rank and total kills immediately upon match conclusion for payout audits.',
        ),
        TournamentRule(
          number: 4,
          title: 'Screen Recording',
          description:
              'Full match screen recording is mandatory for all participants. Recordings must be uploaded within 30 minutes of match end.',
        ),
        TournamentRule(
          number: 5,
          title: 'No Teaming',
          description:
              'Any form of collaboration between solo players is strictly prohibited and will result in immediate disqualification.',
        ),
        TournamentRule(
          number: 6,
          title: 'Mobile Only',
          description:
              'Only mobile devices are permitted. Emulators, tablets, and iPad are not allowed unless explicitly stated in tournament rules.',
        ),
        TournamentRule(
          number: 7,
          title: 'Minimum Level',
          description:
              'Players must have a minimum profile level of 40 to participate in this tournament.',
        ),
        TournamentRule(
          number: 8,
          title: 'POV Requirement',
          description:
              'Top 3 finishers must submit their full match POV recording for verification and content purposes.',
        ),
        TournamentRule(
          number: 9,
          title: 'POV Submission',
          description:
              'Upload your POV recording via the Room Details screen within 30 minutes of match completion.',
        ),
        TournamentRule(
          number: 10,
          title: 'Missed Room Policy',
          description:
              'Players who fail to join the room within 5 minutes of the scheduled start will be forfeited with no refund.',
        ),
        TournamentRule(
          number: 11,
          title: 'Suspension & Refund Policy',
          description:
              'Disqualified players may face a temporary suspension from future tournaments. Entry fees are non-refundable after room generation.',
        ),
        TournamentRule(
          number: 12,
          title: 'Hacking & Panels',
          description:
              'Use of any hacks, mods, or panel apps results in a permanent ban from BooyahX and forfeiture of all winnings.',
        ),
        TournamentRule(
          number: 13,
          title: 'Result Declaration',
          description:
              'Final results are declared within 60 minutes after match completion, pending anti-cheat validation and score reconciliation.',
        ),
      ],
    ),

    // ── featured-elite-cup: FREE FIRE MAX ELITE CUP ──
    TournamentDetail(
      tournament: featuredBanner,
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹30',
      killBountyLabel: 'Kill Bounty Assurance',
      killBountyAmount: '₹30',
      killBountyDescription:
          '₹30 credited per verified kill to your BooyahX wallet within 30 mins after match conclusion and anti-cheat validation.',
      prizeDistribution: const [
        PrizeDistribution(
          rank: 1,
          title: 'Champion',
          subtitle: 'Winner Trophy + Title',
          amount: '₹20,000',
          percentage: '40% of pool',
          isHighlighted: true,
        ),
        PrizeDistribution(
          rank: 2,
          title: 'Runner Up',
          subtitle: 'Silver Tier',
          amount: '₹10,000',
          percentage: '20% of pool',
        ),
        PrizeDistribution(
          rank: 3,
          title: '2nd Runner Up',
          subtitle: 'Bronze Tier',
          amount: '₹5,000',
          percentage: '10% of pool',
        ),
        PrizeDistribution(
          rankRange: '#4 - #10',
          title: 'Top Ten Finishers',
          subtitle: 'Placement Cashout',
          amount: '₹2,000',
          amountEach: '₹2,000 each',
          percentage: 'Total: ₹14,000',
        ),
        PrizeDistribution(
          rankRange: '#11 - #20',
          title: 'Top Twenty',
          subtitle: 'Consolation',
          amount: '₹100',
          amountEach: '₹100 each',
          percentage: 'Total: ₹1,000',
        ),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'Xenon_Striker', uid: '849301294', level: 72, slotLabel: 'SLOT 01'),
        TournamentPlayer(rank: 2, name: 'Hydra_NinjaFF', uid: '190483726', level: 68, slotLabel: 'SLOT 02'),
        TournamentPlayer(rank: 3, name: 'Viper_Ares', uid: '938210384', level: 65, slotLabel: 'SLOT 03'),
      ],
      rules: const [
        TournamentRule(
          number: 1,
          title: 'Room ID & Password',
          description:
              'Credentials will be revealed 15 minutes prior to match launch directly in this app. Ensure you join on your registered in-game account.',
        ),
        TournamentRule(
          number: 2,
          title: 'Fair Play & Anti-Cheat',
          description:
              'Teaming, emulator usage without notice, or 3rd-party script injections lead to an immediate ban and forfeiture of all prizes.',
        ),
        TournamentRule(
          number: 3,
          title: 'Screenshot Verification',
          description:
              'Take a victory screenshot showing your rank and total kills immediately upon match conclusion for payout audits.',
        ),
      ],
    ),

    // ── br-002: FF - SOLO RAMPAGE (full tournament) ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'br-002'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹20',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹20',
      killBountyDescription:
          '₹20 credited per verified kill after match validation.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Champion', amount: '₹3,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: 'Runner Up', amount: '₹2,000'),
        PrizeDistribution(rank: 3, title: '2nd Runner Up', amount: '₹1,000'),
        PrizeDistribution(rankRange: '#4 - #5', title: 'Semi-Finalists', amount: '₹500', amountEach: '₹500 each'),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'GhostFury', uid: '111222333', level: 70, slotLabel: 'SLOT 01'),
        TournamentPlayer(rank: 2, name: 'NitroBlaze', uid: '444555666', level: 66, slotLabel: 'SLOT 02'),
      ],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
        TournamentRule(number: 2, title: 'Fair Play', description: 'No cheating or teaming.'),
      ],
    ),

    // ── br-003: FREE FIRE - SOLO HUNTER ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'br-003'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹15',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹15',
      killBountyDescription: '₹15 credited per verified kill.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Champion', amount: '₹2,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: 'Runner Up', amount: '₹1,500'),
        PrizeDistribution(rank: 3, title: '2nd Runner Up', amount: '₹1,000'),
        PrizeDistribution(rankRange: '#4 - #5', title: 'Semi-Finalists', amount: '₹400', amountEach: '₹400 each'),
      ],
      players: const [],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
        TournamentRule(number: 2, title: 'Fair Play', description: 'No cheating or teaming.'),
      ],
    ),

    // ── duo-001: KALAHARI BLITZ SURVIVAL ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'duo-001'),
      tournamentModeDetail: 'Duo TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹30',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹30',
      killBountyDescription: '₹30 credited per verified kill per team member.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Champion Duo', amount: '₹6,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: 'Runner Up Duo', amount: '₹4,000'),
        PrizeDistribution(rank: 3, title: '2nd Runner Up Duo', amount: '₹2,000'),
        PrizeDistribution(rankRange: '#4 - #5', title: 'Top 5 Duos', amount: '₹1,500', amountEach: '₹1,500 each'),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'DuoMasters', uid: '999888777', level: 74, slotLabel: 'TEAM 01'),
        TournamentPlayer(rank: 2, name: 'BlazeBrothers', uid: '666555444', level: 69, slotLabel: 'TEAM 02'),
      ],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
        TournamentRule(number: 2, title: 'Duo Only', description: 'Both team members must be present.'),
      ],
    ),

    // ── duo-002: DUO SHOWDOWN ARENA ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'duo-002'),
      tournamentModeDetail: 'Duo TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹35',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹35',
      killBountyDescription: '₹35 credited per verified kill.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Champion Duo', amount: '₹5,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: 'Runner Up Duo', amount: '₹3,000'),
        PrizeDistribution(rank: 3, title: '2nd Runner Up Duo', amount: '₹2,000'),
      ],
      players: const [],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
        TournamentRule(number: 2, title: 'Rank Requirement', description: 'Platinum+ rank required.'),
      ],
    ),

    // ── kill-001: PURGATORY KILL RUSH #88 ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'kill-001'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹40',
      killBountyLabel: 'Kill Bounty Assurance',
      killBountyAmount: '₹40',
      killBountyDescription:
          '₹40 credited per verified kill to your BooyahX wallet within 30 mins after match conclusion.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Top Killer', subtitle: 'Highest Kills', amount: '₹2,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: '2nd Highest Kills', amount: '₹1,500'),
        PrizeDistribution(rank: 3, title: '3rd Highest Kills', amount: '₹1,000'),
        PrizeDistribution(rankRange: '#4 - #5', title: 'Top 5 Killers', amount: '₹250', amountEach: '₹250 each'),
      ],
      players: const [
        TournamentPlayer(rank: 1, name: 'KillerInstinct', uid: '112233445', level: 67, slotLabel: 'SLOT 01'),
        TournamentPlayer(rank: 2, name: 'HeadHunter_FF', uid: '556677889', level: 64, slotLabel: 'SLOT 02'),
      ],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
        TournamentRule(number: 2, title: 'Kill Focus', description: 'Rank placement is secondary to kill count.'),
      ],
    ),

    // ── kill-002: SOLO SLAYER ARENA ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'kill-002'),
      tournamentModeDetail: 'TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹35',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹35',
      killBountyDescription: '₹35 credited per verified kill.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Top Killer', amount: '₹1,500', isHighlighted: true),
        PrizeDistribution(rank: 2, title: '2nd Highest', amount: '₹1,000'),
        PrizeDistribution(rank: 3, title: '3rd Highest', amount: '₹500'),
      ],
      players: const [],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
      ],
    ),

    // ── dpk-001: DUO KILL FRENZY ──
    TournamentDetail(
      tournament: tournaments.firstWhere((t) => t.id == 'dpk-001'),
      tournamentModeDetail: 'Duo TPP',
      regionLabel: 'India Region',
      perKillAmount: '₹50',
      killBountyLabel: 'Kill Bounty',
      killBountyAmount: '₹50',
      killBountyDescription: '₹50 credited per verified kill per team member.',
      prizeDistribution: const [
        PrizeDistribution(rank: 1, title: 'Killer Duo', amount: '₹3,000', isHighlighted: true),
        PrizeDistribution(rank: 2, title: '2nd Killer Duo', amount: '₹2,000'),
        PrizeDistribution(rank: 3, title: '3rd Killer Duo', amount: '₹1,500'),
      ],
      players: const [],
      rules: const [
        TournamentRule(number: 1, title: 'Room ID & Password', description: 'Shared 15 minutes before start.'),
      ],
    ),
  ];

  // ── Helper Methods ──

  /// Get all tournaments for a given category.
  static List<Tournament> byCategory(TournamentCategory category) {
    if (category == TournamentCategory.all) return tournaments;
    return tournaments.where((t) => t.category == category).toList();
  }

  /// Get the number of live/active tournaments.
  static int get liveCount =>
      tournaments.where((t) => t.status == TournamentStatus.live).length;

  /// Get a tournament by its ID. Returns null if not found.
  static Tournament? byId(String id) {
    if (id == featuredBanner.id) return featuredBanner;
    try {
      return tournaments.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get the full detail for a tournament by its ID. Returns null if not found.
  static TournamentDetail? detailById(String id) {
    try {
      return _details.firstWhere((d) => d.tournament.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Category display names.
  static const Map<TournamentCategory, String> categoryLabels = {
    TournamentCategory.soloBr: 'SOLO BR',
    TournamentCategory.duoBr: 'DUO BR',
    TournamentCategory.duoPerKill: 'DUO PER KILL',
    TournamentCategory.soloPerKill: 'SOLO PER KILL',
  };
}
