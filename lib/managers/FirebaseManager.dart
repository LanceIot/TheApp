import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_app/models/CardModel.dart';
import 'package:the_app/models/OrderModel.dart';
import 'package:the_app/models/Product.dart';
import 'package:the_app/models/UserModel.dart';
import 'package:the_app/models/ShopCartProduct.dart';

class FirebaseManager {
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  FirebaseManager._();

  static final FirebaseManager _instance = FirebaseManager._();
  final FirebaseAuth auth = FirebaseAuth.instance;

  factory FirebaseManager.getInstance() {
    return _instance;
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();

  //! Auth methods

  void signUp(String name, String lastname, String email, String password,
      Function(bool, FirebaseAuthException?) completion) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'lastname': lastname,
        'email': email,
        'password': password
      });
      completion(true, null);
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }

  void signIn(String email, String password,
      Function(bool, FirebaseAuthException?) completion) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      completion(true, null);
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }

  void signOut(Function(bool, FirebaseAuthException?) completion) async {
    try {
      auth.signOut();
      completion(true, null);
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }

  void fetchData(Function(List<Product>?) completion) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("products").get();

      List<Product> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          description: data['description'] ?? '',
          price: data['price'] ?? 0.0,
          tags: List<String>.from(data['tags'] ?? []),
        );
      }).toList();
      completion(products);
    } catch (e) {
      print('Error fetching data: $e');
      completion(null);
    }
  }

//! User Data methods

  Future<void> fetchUserData(Function(UserModel?) completion) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        UserModel user = UserModel(
          email: userData['email'] ?? '',
          password: userData['password'] ?? '',
          name: userData['name'] ?? '',
          lastname: userData['lastname'] ?? '',
        );
        completion(user);
      } else {
        completion(null);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      completion(null);
    }
  }

  Future<void> updateUserData(String name, String lastname) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userReference =
          FirebaseFirestore.instance.collection("users").doc(uid);

      await userReference.update({
        'name': name,
        'lastname': lastname,
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

//! Shopping Cart methods

  void addToShoppingCart(Product product,
      Function(bool, FirebaseAuthException?) completion) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        ShopCartProduct shopCartProduct = ShopCartProduct(
          id: product.id,
          name: product.name,
          image: product.image,
          description: product.description,
          price: product.price,
          tags: product.tags,
          productCount: 1,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('shopCartProducts')
            .add({
          'id': shopCartProduct.id,
          'name': shopCartProduct.name,
          'image': shopCartProduct.image,
          'description': shopCartProduct.description,
          'price': shopCartProduct.price,
          'tags': shopCartProduct.tags,
          'productCount': shopCartProduct.productCount,
        });

        completion(true, null);
      } else {
        completion(false, null);
      }
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }

  Future<void> fetchShopCartProducts(
      Function(List<ShopCartProduct>?) completion) async {
    try {
      List<ShopCartProduct> shopCartProducts = [];
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

      var cartSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("shopCartProducts")
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot
            in cartSnapshot.docs) { 
          Map<String, dynamic> shopCartData = snapshot.data();

          print(shopCartData['name']);

          ShopCartProduct shopCartProduct = ShopCartProduct(
            id: shopCartData['id'],
            name: shopCartData['name'],
            image: shopCartData['image'],
            description: shopCartData['description'],
            price: shopCartData['price'],
            tags: shopCartData['tags'],
            productCount: shopCartData['productCount'],
          );

          shopCartProducts.add(shopCartProduct);
        }

        completion(shopCartProducts);
      } else {
        completion(null);
      }
    } catch (e, stackTrace) {
      print('Error fetching user data: $e\n$stackTrace');
      completion(null);
    }
  }

//! Card Info methods

  void addCardInfo(
      CardModel card, Function(bool, FirebaseAuthException?) completion) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        CardModel cardModel = CardModel(
          id: card.id,
          number: card.number,
          month: card.month,
          year: card.year,
          ccv: card.ccv,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cards')
            .doc("${cardModel.id}")
            .set({
          'cardNumber': cardModel.number,
          'month': cardModel.month,
          'year': cardModel.year,
          'ccv': cardModel.ccv,
        });

        completion(true, null);
      } else {
        completion(false, null);
      }
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }

  Future<void> fetchCardsInfo(Function(List<CardModel>?) completion) async {
    try {
      List<CardModel> cardModels = [];
      String uid = FirebaseAuth.instance.currentUser!.uid;

      var cardSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("cards")
          .get();

      if (cardSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot
            in cardSnapshot.docs) {
          Map<String, dynamic> cardData = snapshot.data();

          CardModel card = CardModel(
            id: cardData['id'],
            number: cardData['number'] ?? '',
            month: cardData['month'] ?? '',
            year: cardData['year'] ?? '',
            ccv: cardData['ccv'] ?? '',
          );

          cardModels.add(card);
        }

        completion(cardModels);
      } else {
        completion(null);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      completion(null);
    }
  }

  Future<void> fetchCardInfo(int index, Function(CardModel?) completion) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot cardSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("cards")
          .doc("$index")
          .get();

      if (cardSnapshot.exists) {
        Map<String, dynamic> cardData =
            cardSnapshot.data() as Map<String, dynamic>;

        CardModel card = CardModel(
          id: index,
          number: cardData['cardNumber'],
          month: cardData['month'],
          year: cardData['year'],
          ccv: cardData['ccv'],
        );
        completion(card);
      } else {
        completion(null);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      completion(null);
    }
  }

  Future<void> updateCardData(
      int index, String number, String month, String year, String ccv) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userReference = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("cards")
          .doc("$index");

      await userReference.update({
        'cardNumber': number,
        'month': month,
        'year': year,
        'ccv': ccv,
      });
    } catch (e) {
      print('Error updating card data: $e');
    }
  }

  //! Orders

  void addOrder(OrderModel orderModel,
      Function(bool, FirebaseAuthException?) completion) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        OrderModel order = OrderModel(
            adress: orderModel.adress,
            shopCartProducts: orderModel.shopCartProducts,
            paymentWay: orderModel.paymentWay,
            totalPrice: orderModel.totalPrice);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('orders')
            .add({
          'adress': order.adress,
          'shopCartProducts': order.shopCartProducts,
          'paymentWay': order.paymentWay,
          'totalPrice': order.totalPrice,
        });

        completion(true, null);
      } else {
        completion(false, null);
      }
    } on FirebaseAuthException catch (error) {
      completion(false, error);
    }
  }
}
