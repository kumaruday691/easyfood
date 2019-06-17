import 'package:easyfood/domain/restarurantsRepository.dart';
import 'package:easyfood/domain/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';

class UnitOfWork extends Model with RestaurantsRepository
{
  
  // region Constructors
  UnitOfWork()
  {
    restaurants = [];
    isLoading = false;
  }
  
  // region Properties

}