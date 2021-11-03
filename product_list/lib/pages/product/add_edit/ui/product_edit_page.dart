import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list/models/product.dart';
import 'package:product_list/models/product_category.dart';
import 'package:product_list/pages/product/add_edit/bloc/product_edit_bloc.dart';
import 'package:product_list/pages/product/list/bloc/product_bloc.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({Key? key, this.product}) : super(key: key);

  final Product? product;

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProductEditBloc()..add(ProductEditLoaded(widget.product)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Product template edit page'),
      actions: [
        IconButton(
          onPressed: () {
            context.read<ProductEditBloc>().add(
                  ProductEditSaved(
                    Product(
                      name: _nameController.text,
                      price: double.tryParse(_priceController.text),
                    ),
                  ),
                );
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ProductEditBloc, ProductEditState>(
      buildWhen: (ProductEditState previous, ProductEditState state) {
        return ![
          ProductEditCategoryChangeSuccess,
          ProductEditSaveSuccess,
          ProductEditSaveFailure,
          ProductEditSaveSuccess
        ].contains(state.runtimeType);
      },
      listener: (BuildContext context, ProductEditState state) {
        if (state is ProductEditLoadSuccess) {
          final product = state.data.product;
          _nameController.text = product.name ?? '';
          _priceController.text = product.price?.toString() ?? '0';
          return;
        }

        if (state is ProductEditSaveSuccess) {
          Navigator.of(context).pop(state.data.product);
          return;
        }

        if (state is ProductEditSaveFailure) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Lỗi'),
                content: Text(state.error),
              )
          );
          return;
        }


      },
      builder: (BuildContext context, ProductEditState state) {
        if (state is ProductEditLoading) {
          return _buildLoading();
        }

        if (state is ProductEditLoadFailure) {
          return _buildLoadError(state.error);
        }

        if (state is ProductEditDataAvailable) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: _buildContent(state.data.product),
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

  Widget _buildLoadError(String error) {
    return Center(child: Text(error));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildContent(Product product) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Tên sản phẩm'),
        ),
        TextFormField(
          controller: _priceController,
          decoration: InputDecoration(labelText: 'Giá sản phẩm'),
        ),
        _ProductCategoryDropDown(),
      ],
    );
  }
}

class _ProductCategoryDropDown extends StatelessWidget {
  const _ProductCategoryDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductEditBloc>().state;

    if (state is ProductEditDataAvailable) {
      return SizedBox(
        height: 50,
        child: DropdownButton<ProductCategory>(
          items: state.data.productCategories
              .map<DropdownMenuItem<ProductCategory>>((ProductCategory value) {
            return DropdownMenuItem<ProductCategory>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
          value: state.data.product.category,
          onChanged: (ProductCategory? category) {
            if (category != null) {
              context
                  .read<ProductEditBloc>()
                  .add(ProductEditCategoryChanged(category));
            }
          },
        ),
      );
    }

    return const SizedBox();
  }
}
