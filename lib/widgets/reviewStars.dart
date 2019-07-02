import 'package:flutter/material.dart';

class ReviewStars extends StatelessWidget {

  int index;
  double rating = .0;
  Function onRateChanged;
  IconData reviewIcon;

 ReviewStars(this.rating, this.onRateChanged, this.reviewIcon);
      
  _buildStars(BuildContext context, int index){
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        this.reviewIcon ?? Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        this.reviewIcon ?? Icons.star_half,
        color: Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        this.reviewIcon ?? Icons.star,
        color: Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap: onRateChanged == null ? null : () => onRateChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return new Row(children: new List.generate(5, (index) => _buildStars(context, index)));
  }
}