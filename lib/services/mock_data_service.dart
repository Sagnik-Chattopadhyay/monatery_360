import '../models/monastery_model.dart';
import '../models/event_model.dart';
import '../models/archive_model.dart';
import '../models/tourism_service_model.dart';

class MockDataService {
  static List<MonasteryModel> getMonasteries() {
    return [
      MonasteryModel(
        id: 'rumtek',
        name: 'Rumtek Monastery',
        locationName: 'Gangtok, Sikkim',
        latitude: 27.3005,
        longitude: 88.6138,
        establishedYear: 1966,
        era: '20th Century (Modern)',
        orderSect: 'Kagyu Order',
        description:
            'Rumtek Monastery, also called the Dharma Chakra Centre, is a seat-in-exile of the Gyalwang Karmapa. Located 24 km from Gangtok, it houses golden stupas, rare murals, and sacred shrines.',
        imageUrl:
            'assets/images/rumtek_preview.jpg',
        panoramaUrls: [
          'assets/panoramas/rumtek_360.jpg',
        ],
        archivesCount: 24,
        isFeatured: true,
        altitude: '1,500m',
        nearbyAttractions: ['Ranka Monastery', 'Banjhakri Waterfalls', 'Jawaharlal Nehru Botanical Garden'],
      ),
      MonasteryModel(
        id: 'pemayangtse',
        name: 'Pemayangtse Monastery',
        locationName: 'Pelling, West Sikkim',
        latitude: 27.3060,
        longitude: 88.2430,
        establishedYear: 1705,
        era: '18th Century',
        orderSect: 'Nyingma Order',
        description:
            'One of the oldest and premier monasteries in Sikkim, planned and founded by Lama Lhatsun Chempo in 1705. It features the famous 7-tiered wooden structure of Sangtok Palri.',
        imageUrl:
            'assets/images/pemayangtse_preview.jpg',
        panoramaUrls: [
          'assets/panoramas/pemayangtse_360.jpg',
        ],
        archivesCount: 18,
        isFeatured: true,
        altitude: '2,085m',
        nearbyAttractions: ['Rabdentse Ruins', 'Khecheopalri Sacred Lake', 'Pelling Skywalk'],
      ),
      MonasteryModel(
        id: 'enchey',
        name: 'Enchey Monastery',
        locationName: 'Gangtok, East Sikkim',
        latitude: 27.3385,
        longitude: 88.6186,
        establishedYear: 1840,
        era: '19th Century',
        orderSect: 'Nyingma Order',
        description:
            'Enchey Monastery means "Solitary Temple". Built on a stunning ridge above Gangtok, it belongs to the Nyingma order and hosts the annual Detor Chaam mask dance.',
        imageUrl:
            'assets/images/enchey_preview.jpg',
        panoramaUrls: [
          'assets/panoramas/enchey_360.jpg',
        ],
        archivesCount: 12,
        isFeatured: true,
        altitude: '1,800m',
        nearbyAttractions: ['Ganesh Tok', 'Tashi Viewpoint', 'Himalayan Zoological Park'],
      ),
      MonasteryModel(
        id: 'tashiding',
        name: 'Tashiding Monastery',
        locationName: 'Yuksom / Geyzing',
        latitude: 27.3320,
        longitude: 88.2980,
        establishedYear: 1641,
        era: '17th Century',
        orderSect: 'Nyingma Order',
        description:
            'Perched atop a heart-shaped hill between the Rangeet and Rathong rivers, Tashiding is considered the spiritual heart of Sikkim. Famous for the sacred Holy Water Festival (Bumchu).',
        imageUrl:
            'assets/images/tashiding_preview.jpg',
        panoramaUrls: [
          'assets/panoramas/tashiding_360.jpg',
        ],
        archivesCount: 31,
        isFeatured: false,
        altitude: '1,460m',
        nearbyAttractions: ['Yuksom First Capital', 'Kanchenjunga National Park Gate'],
      ),
    ];
  }

  static List<EventModel> getEvents() {
    return [
      EventModel(
        id: 'event_1',
        title: 'Bumchu Holy Water Sacred Ceremony',
        monasteryId: 'tashiding',
        monasteryName: 'Tashiding Monastery',
        createdByUid: 'local_monk_1',
        createdByName: 'Lama Norbu (Local Host)',
        eventDate: DateTime.now().add(const Duration(days: 5)),
        timeString: '06:00 AM - 04:00 PM',
        category: 'Sacred Ritual',
        description:
            'Annual Bumchu ritual where the sealed pot of holy water is opened to predict the prosperity of the coming year. Open to all pilgrims and visitors.',
        bannerImageUrl:
            'assets/images/tashiding_preview.jpg',
        totalSeats: 200,
        bookedSeats: 84,
        entryFee: 0.0,
      ),
      EventModel(
        id: 'event_2',
        title: 'Kagyed Sacred Cham Mask Dance',
        monasteryId: 'rumtek',
        monasteryName: 'Rumtek Monastery',
        createdByUid: 'local_sec_2',
        createdByName: 'Tashi Bhutia (Rumtek Local Committee)',
        eventDate: DateTime.now().add(const Duration(days: 12)),
        timeString: '09:30 AM - 03:30 PM',
        category: 'Monastic Dance',
        description:
            'Traditional mask dance performed by monks symbolizing the destruction of evil forces and bringing peace for the Sikkimese New Year.',
        bannerImageUrl:
            'assets/images/rumtek_preview.jpg',
        totalSeats: 150,
        bookedSeats: 120,
        entryFee: 0.0,
      ),
      EventModel(
        id: 'event_3',
        title: 'Sunset Butter Lamp & Meditation Workshop',
        monasteryId: 'enchey',
        monasteryName: 'Enchey Monastery',
        createdByUid: 'local_guide_3',
        createdByName: 'Pemba Lepcha (Local Resident)',
        eventDate: DateTime.now().add(const Duration(days: 2)),
        timeString: '05:00 PM - 06:30 PM',
        category: 'Meditation & Ritual',
        description:
            'Join local residents and monks in lighting 108 butter lamps while learning mindfulness meditation overlooking the Kanchenjunga peaks.',
        bannerImageUrl:
            'assets/images/enchey_preview.jpg',
        totalSeats: 40,
        bookedSeats: 18,
        entryFee: 100.0,
      ),
    ];
  }

  static List<ArchiveModel> getArchives() {
    return [
      ArchiveModel(
        id: 'arch_1',
        title: 'Prajnaparamita Sutra Illuminated Folio',
        monasteryId: 'rumtek',
        monasteryName: 'Rumtek Monastery',
        category: 'manuscript',
        era: '17th Century',
        imageUrl:
            'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=800&q=80',
        description:
            'Gold ink calligraphy on indigo paper depicting the Perfection of Wisdom sutras brought from Tibet.',
        language: 'Tibetan',
      ),
      ArchiveModel(
        id: 'arch_2',
        title: 'Lhatsun Chempo Sangtok Palri Mural Scan',
        monasteryId: 'pemayangtse',
        monasteryName: 'Pemayangtse Monastery',
        category: 'mural',
        era: '18th Century',
        imageUrl:
            'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=800&q=80',
        description:
            'High-resolution digital scan of the 7-tiered celestial palace mural painted by royal Sikkimese artists.',
        language: 'Iconographic',
      ),
      ArchiveModel(
        id: 'arch_3',
        title: 'Royal Edict of Chogyal Tensung Namgyal',
        monasteryId: 'tashiding',
        monasteryName: 'Tashiding Monastery',
        category: 'historical_record',
        era: '17th Century',
        imageUrl:
            'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
        description:
            'Scanned seal and charter granting land protection for the sacred hill of Tashiding in 1642.',
        language: 'Sikkimese Bhutia',
      ),
    ];
  }

  static List<TourismServiceModel> getTourismServices() {
    return [
      TourismServiceModel(
        id: 'serv_1',
        title: 'Gangtok to Rumtek Shared & Private Cabs',
        serviceType: 'Transport / Cab',
        providerName: 'Sikkim Eco Taxi Drivers Association',
        phoneContact: '+91 98320 12345',
        location: 'Gangtok Taxi Stand',
        pricing: '₹500 / vehicle (one-way)',
        rating: 4.9,
        imageUrl:
            'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=800&q=80',
        coveredMonasteries: ['Rumtek Monastery', 'Ranka Monastery', 'Enchey Monastery'],
      ),
      TourismServiceModel(
        id: 'serv_2',
        title: 'West Sikkim Heritage & Monastery Guided Tour',
        serviceType: 'Local Heritage Guide',
        providerName: 'Sonam Lepcha (Certified Cultural Guide)',
        phoneContact: '+91 97331 88765',
        location: 'Pelling / Geyzing',
        pricing: '₹1,500 / day',
        rating: 5.0,
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        coveredMonasteries: ['Pemayangtse Monastery', 'Tashiding Monastery', 'Dubdi Monastery'],
      ),
      TourismServiceModel(
        id: 'serv_3',
        title: 'Pemayangtse Monastery Ridge Homestay',
        serviceType: 'Homestay / Monastery Stay',
        providerName: 'Yangchen Bhutia',
        phoneContact: '+91 94341 55432',
        location: 'Pelling (5 mins from Pemayangtse)',
        pricing: '₹1,800 / night (Includes Organic Meals)',
        rating: 4.8,
        imageUrl:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80',
        coveredMonasteries: ['Pemayangtse Monastery'],
      ),
    ];
  }
}
