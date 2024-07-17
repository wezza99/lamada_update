import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/category_widget.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  final double? maxValue;
  const FilterWidget({super.key, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: true);



    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        bool canNotFilter = searchProvider.selectedPriceIndex == null && searchProvider.rating == null &&  categoryProvider.selectedCategoryList.isEmpty && searchProvider.cuisineIds == null;

        return _Flexible(child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),


            Row(children: [

              const SizedBox(width: Dimensions.paddingSizeLarge),
              Text(getTranslated('filter', context)!, textAlign: TextAlign.center, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

              const SizedBox(width: Dimensions.paddingSizeLarge),

            ]),
            const SizedBox(height: Dimensions.paddingSizeLarge),


            Flexible(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                /// Price section
                Text(getTranslated('price', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(height: 30, child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
                  SliverList.builder(
                    itemCount: searchProvider.priceFilterList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: Material(
                        color: searchProvider.selectedPriceIndex == index ? Theme.of(context).primaryColor.withOpacity(0.9) : Colors.transparent,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () => searchProvider.updatePriceFilter(index),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: Tooltip(
                            message: '[${searchProvider.priceFilterList[index].first} - ${(searchProvider.priceFilterList[index].last - 0.01).toStringAsFixed(2)}]',
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: searchProvider.selectedPriceIndex == index ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Text(
                                searchProvider.priceFilterList[index].last.toString().replaceAll(RegExp('[^0]'), '').replaceAll(RegExp('0'), '\$'),
                                textAlign: TextAlign.center,
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: searchProvider.selectedPriceIndex == index ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                /// Rating section
                Text(getTranslated('ratings', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Center(child: SizedBox(height: 30, child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault), child: InkWell(
                      child: Icon(
                        (searchProvider.rating ?? 0) < (index + 1) ? Icons.star_border_rounded : Icons.star_rounded,
                        size: Dimensions.fontSizeOverLarge,
                        color: (searchProvider.rating ?? 0) < (index + 1) ? Theme.of(context).hintColor.withOpacity(0.7) : Theme.of(context).primaryColor,
                      ),
                      onTap: () => searchProvider.onChangeRating(index + 1),
                    ));
                  },
                ))),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                /// Category section
                Text(getTranslated('category', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Consumer<CategoryProvider>(
                  builder: (context, category, child) {
                    return category.categoryList != null ? SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: Dimensions.paddingSizeDefault * 2,
                          ),
                          itemCount: category.categoryList?.length,
                          itemBuilder: (context,index){
                            return Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                              child: InkWell(
                                onTap: (){
                                  if(category.categoryList?[index].id != null) {
                                    category.updateSelectCategory(id: category.categoryList?[index].id ?? 0);
                                  }
                                },
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [

                                  Container(
                                    transform: Matrix4.translationValues(-2, 0,0),
                                    child: Checkbox(
                                      value: category.selectedCategoryList.contains(category.categoryList?[index].id),
                                      activeColor: Theme.of(context).primaryColor,
                                      checkColor: Theme.of(context).primaryColor,
                                      fillColor: WidgetStateProperty.all(Colors.transparent),
                                      side: WidgetStateBorderSide.resolveWith((states) {
                                        if(states.contains(WidgetState.pressed)){
                                          return BorderSide(color: category.selectedCategoryList.contains(category.categoryList?[index].id) ? Theme.of(context).primaryColor : Theme.of(context).hintColor);
                                        }
                                        else{
                                          return BorderSide(color: category.selectedCategoryList.contains(category.categoryList?[index].id) ? Theme.of(context).primaryColor : Theme.of(context).hintColor);
                                        }
                                      }),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                      onChanged:(bool? newValue) {
                                        if(category.categoryList?[index].id != null) {
                                          category.updateSelectCategory(id: category.categoryList?[index].id ?? 0);
                                        }
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -3),
                                    ),
                                  ),

                                  Text(
                                    category.categoryList?[index].name ?? '',
                                    textAlign: TextAlign.center,
                                    style: rubikRegular.copyWith(
                                        fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                                        color: category.selectedCategoryList.contains(category.categoryList?[index].id) ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeDefault),

                                ]),
                              ),
                            );
                          }
                      ),
                    )
                        : const CategoryShimmer();
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                /// Cuisine section
                Text(getTranslated('cuisine', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                if(searchProvider.cuisineList?.isNotEmpty ?? false) SizedBox(child: Wrap(
                  spacing: Dimensions.paddingSizeSmall,
                  runSpacing: Dimensions.paddingSizeSmall,
                  children: searchProvider.cuisineList!.map((cuisine) {
                    bool isSelected = (searchProvider.cuisineIds?.contains(cuisine.id) ?? false);

                    return Material(
                      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.9) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => searchProvider.onSelectCuisineList(cuisine.id),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(
                              width: 0.5,
                              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.2),
                            ),
                          ),
                          child: Text(cuisine.name ?? '', style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: (searchProvider.cuisineIds?.contains(cuisine.id) ?? false) ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                          )),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]),
            )),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
              child: Row(children: [

                Expanded(child: CustomButtonWidget(
                  onTap: () {
                    searchProvider.resetFilterData();
                  },
                  height: 40,
                  btnTxt: getTranslated('reset', context),
                  textStyle: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                  borderRadius: Dimensions.radiusSmall,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                )),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(flex: 2, child: CustomButtonWidget(
                  isLoading: searchProvider.isLoading,
                  height: 40,
                  btnTxt: getTranslated('apply', context),
                  textStyle: rubikMedium.copyWith(color: Theme.of(context).cardColor),
                  borderRadius: Dimensions.radiusSmall,
                  onTap: canNotFilter ? null :  () async {

                    searchProvider.searchProduct(offset: 1, name: searchProvider.searchText, context: context);

                    if(context.mounted) {
                      context.pop();
                    }
                  },
                )),

              ]),
            ),

          ],
        ));
      },
    );
  }
}



class _Flexible extends StatelessWidget {
  final Widget child;
  const _Flexible({required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? child : Flexible(child: child);
  }
}
