import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/models/product.dart';
import 'package:flutter_bloc_example/pages/product/add_edit/ui/product_edit_page.dart';
import 'package:flutter_bloc_example/pages/product/list/bloc/product_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProductBloc()..add(ProductLoaded()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: _buildBody(),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Product template page'),
      actions: [
        IconButton(
          onPressed: () {
            _insert(context);
          },
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Future<void> _insert(BuildContext context) async {
    final Product? product = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProductEditPage();
        },
      ),
    );

    if (product != null) {
      context.read<ProductBloc>().add(
            ProductInserted(product),
          );
    }
  }

  Widget _buildBody() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (BuildContext context, ProductState state) {},
      builder: (BuildContext context, ProductState state) {
        if (state is ProductLoading) {
          return _buildLoading();
        }

        if (state is ProductLoadFailure) {
          return _buildLoadError(state.error);
        }

        if (state is ProductDataAvailable) {
          return Stack(
            children: [
              Column(
                children: [
                  _buildAction(context),
                  Expanded(
                    child: _buildProducts(
                        state.data.products, state.data.selectedProducts),
                  ),
                ],
              ),
              if (state is ProductBusy)
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: Center(
                    child: _buildLoading(),
                  ),
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildAction(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.read<ProductBloc>().add(
                  ProductSelectItemsDeleted(),
                );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget _buildLoadError(String error) {
    return Center(child: Text(error));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildProducts(
      List<Product> products, List<Product> selectedProducts) {
    return Builder(
      builder: (context) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent) {
              context.read<ProductBloc>().add(ProductLoadMore());
            }

            return true;
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _ProductItem(
                        product: products[index],
                        isSelected: selectedProducts
                            .any((element) => element.id == products[index].id),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
                _buildLoadingMore(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMore(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {

        if (state is ProductLoadingMore) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({Key? key, required this.product, this.isSelected = false})
      : super(key: key);

  final Product product;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProductBloc>().add(
              ProductChecked(product),
            );
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: _buildActions(context),
        child: ListTile(
          trailing: Checkbox(
            onChanged: (bool? value) {
              context.read<ProductBloc>().add(
                    ProductChecked(product),
                  );
            },
            value: isSelected,
          ),
          title: Text(product.name ?? ''),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      Material(
        color: Colors.blue,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProductEditPage(
                    product: product,
                  );
                },
              ),
            );
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
      Material(
        color: Colors.red,
        child: IconButton(
          onPressed: () {
            context.read<ProductBloc>().add(
                  ProductDeleted(product),
                );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    ];
  }
}
