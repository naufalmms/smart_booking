import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'smart_booking_v3.db');
    // Force reset database on every init for testing
    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Wallet Table
    await db.execute('''
      CREATE TABLE wallet_balance(
        currency TEXT PRIMARY KEY,
        amount REAL
      )
    ''');

    // Transactions Table
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        type TEXT,
        amount REAL,
        currency TEXT,
        date TEXT,
        status TEXT,
        description TEXT
      )
    ''');

    // Services Table
    await db.execute('''
      CREATE TABLE services(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        icon_name TEXT,
        price REAL,
        price_gp INTEGER,
        currency TEXT,
        duration TEXT,
        is_available INTEGER
      )
    ''');

    // Bookings Table
    await db.execute('''
      CREATE TABLE bookings(
        id TEXT PRIMARY KEY,
        service_id TEXT,
        date TEXT,
        time TEXT,
        location TEXT,
        status TEXT,
        payment_method TEXT,
        amount REAL,
        currency TEXT,
        FOREIGN KEY(service_id) REFERENCES services(id)
      )
    ''');

    // Rewards Table
    await db.execute('''
      CREATE TABLE rewards(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        points_cost INTEGER,
        category TEXT,
        is_claimed INTEGER,
        expiry_date TEXT,
        tag TEXT,
        discount TEXT,
        type TEXT
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final batch = db.batch();

    // Seed Wallet
    batch.insert('wallet_balance', {'currency': 'RM', 'amount': 250.50});
    batch.insert('wallet_balance', {'currency': 'GP', 'amount': 1200.0});

    // Seed Services
    batch.insert('services', {
      'id': 'valet',
      'name': 'Premium Valet Service',
      'description': 'Professional valet parking at airport terminals',
      'icon_name': 'car',
      'price': 45.0,
      'price_gp': 450,
      'currency': 'RM',
      'duration': '1-4 hours',
      'is_available': 1,
    });
    batch.insert('services', {
      'id': 'carwash',
      'name': 'Express Car Wash',
      'description': 'Quick exterior and interior cleaning',
      'icon_name': 'droplet',
      'price': 25.0,
      'price_gp': 250,
      'currency': 'RM',
      'duration': '30 mins',
      'is_available': 1,
    });
    batch.insert('services', {
      'id': 'bay_reservation',
      'name': 'Premium Bay Reservation',
      'description': 'Reserved parking bay with premium features',
      'icon_name': 'map-pin',
      'price': 60.0,
      'price_gp': 600,
      'currency': 'RM',
      'duration': '24 hours',
      'is_available': 1,
    });
    batch.insert('services', {
      'id': 'standard_valet',
      'name': 'Standard Valet',
      'description': 'Basic valet parking service',
      'icon_name': 'car',
      'price': 30.0,
      'price_gp': 300,
      'currency': 'RM',
      'duration': '1-2 hours',
      'is_available': 0,
    });

    // Seed Bookings (Dummy Data)
    // 1. Confirmed Booking (Paid with RM)
    batch.insert('bookings', {
      'id': 'b1',
      'service_id': 'valet',
      'date': '2024-12-25T14:00:00.000',
      'time': '14:00',
      'location': 'Terminal 1, Gate 3',
      'status': 'confirmed',
      'payment_method': 'wallet',
      'amount': 45.0,
      'currency': 'RM',
    });

    // 2. Completed Booking (Paid with GP)
    batch.insert('bookings', {
      'id': 'b2',
      'service_id': 'carwash',
      'date': '2024-12-22T10:30:00.000',
      'time': '10:30',
      'location': 'Main Parking Area A',
      'status': 'completed',
      'payment_method': 'gp',
      'amount': 250.0,
      'currency': 'GP',
    });

    // Seed Rewards
    // 1. Claimed Voucher
    batch.insert('rewards', {
      'id': 'v1',
      'title': '50% OFF Car Wash',
      'description': 'Premium exterior and interior car wash service',
      'points_cost': 0,
      'category': 'Service',
      'is_claimed': 1,
      'expiry_date': DateTime.now()
          .add(const Duration(hours: 24))
          .toIso8601String(),
      'tag': null,
      'discount': '50%',
      'type': 'voucher',
    });

    // 2. Available Offer (Campaign)
    batch.insert('rewards', {
      'id': 'o1',
      'title': 'RM20 Valet Discount',
      'description': 'Special discount for airport valet parking',
      'points_cost': 0,
      'category': 'Campaign',
      'is_claimed': 0,
      'expiry_date': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
      'tag': 'Campaign',
      'discount': 'RM20 OFF',
      'type': 'offer',
    });

    // 3. Available Offer (Loyalty)
    batch.insert('rewards', {
      'id': 'o2',
      'title': 'Free Bay Upgrade',
      'description': 'Upgrade to premium bay for free',
      'points_cost': 0,
      'category': 'Loyalty',
      'is_claimed': 0,
      'expiry_date': DateTime.now()
          .add(const Duration(days: 5))
          .toIso8601String(),
      'tag': 'Loyalty',
      'discount': 'Free',
      'type': 'offer',
    });

    // 4. Available Offer (Event)
    batch.insert('rewards', {
      'id': 'o3',
      'title': '200 GP Coins Bonus',
      'description': 'Book any service this week and get bonus coins',
      'points_cost': 0,
      'category': 'Event',
      'is_claimed': 0,
      'expiry_date': DateTime.now()
          .add(const Duration(days: 4))
          .toIso8601String(),
      'tag': 'Event',
      'discount': '+200 GP',
      'type': 'offer',
    });

    await batch.commit(noResult: true);
  }
}
