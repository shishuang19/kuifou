import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/asset.dart';
import '../../domain/services/validation_service.dart';
import '../../../profile/domain/entities/profile_preferences.dart';
import '../../../profile/presentation/providers/profile_preferences_provider.dart';
import 'asset_list_provider.dart';
import '../../../../core/errors/app_exception.dart';

part 'asset_form_provider.g.dart';

// Asset form state
class AssetFormState {
  final String? assetId; // null for create, non-null for edit
  final String name;
  final String categoryId;
  final String icon;
  final double purchasePrice;
  final DateTime purchaseDate;
  final DateTime? warrantyEndDate;
  final int? expectedLifeDays;
  final DepreciationMethodPreference depreciationMethod;
  final AssetStatus status;
  final String? note;
  final Map<String, String?> errors;
  final bool isLoading;

  const AssetFormState({
    this.assetId,
    this.name = '',
    this.categoryId = '',
    this.icon = '📦',
    this.purchasePrice = 0.0,
    required this.purchaseDate,
    this.warrantyEndDate,
    this.expectedLifeDays,
    this.depreciationMethod = DepreciationMethodPreference.straightLine,
    this.status = AssetStatus.using,
    this.note,
    this.errors = const {},
    this.isLoading = false,
  });

  AssetFormState copyWith({
    String? assetId,
    String? name,
    String? categoryId,
    String? icon,
    double? purchasePrice,
    DateTime? purchaseDate,
    DateTime? warrantyEndDate,
    int? expectedLifeDays,
    DepreciationMethodPreference? depreciationMethod,
    AssetStatus? status,
    String? note,
    Map<String, String?>? errors,
    bool? isLoading,
  }) {
    return AssetFormState(
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      icon: icon ?? this.icon,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      expectedLifeDays: expectedLifeDays ?? this.expectedLifeDays,
      depreciationMethod: depreciationMethod ?? this.depreciationMethod,
      status: status ?? this.status,
      note: note ?? this.note,
      errors: errors ?? this.errors,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Factory from Asset (for editing)
  factory AssetFormState.fromAsset(Asset asset) {
    return AssetFormState(
      assetId: asset.id,
      name: asset.name,
      categoryId: asset.categoryId,
      icon: asset.icon,
      purchasePrice: asset.purchasePrice,
      purchaseDate: asset.purchaseDate,
      warrantyEndDate: asset.warrantyEndDate,
      expectedLifeDays: asset.expectedLifeDays,
      depreciationMethod: DepreciationMethodPreference.fromExpectedLifeDays(
        asset.expectedLifeDays,
      ),
      status: asset.status,
      note: asset.note,
    );
  }

  bool get isValid => errors.isEmpty;
}

// Asset form notifier
@riverpod
class AssetFormNotifier extends _$AssetFormNotifier {
  @override
  AssetFormState build() {
    final defaultMethod = ref.read(defaultDepreciationMethodPreferenceProvider);

    return AssetFormState(
      purchaseDate: DateTime.now(),
      expectedLifeDays: defaultMethod.defaultExpectedLifeDays,
      depreciationMethod: defaultMethod,
    );
  }

  // Load asset for editing
  void loadAsset(Asset asset) {
    state = AssetFormState.fromAsset(asset);
  }

  // Reset form
  void reset() {
    final defaultMethod = ref.read(defaultDepreciationMethodPreferenceProvider);

    state = AssetFormState(
      purchaseDate: DateTime.now(),
      expectedLifeDays: defaultMethod.defaultExpectedLifeDays,
      depreciationMethod: defaultMethod,
    );
  }

  // Update fields
  void updateName(String name) {
    state = state.copyWith(
      name: name,
      errors: {...state.errors}..remove('name'),
    );
  }

  void updateCategoryId(String categoryId) {
    state = state.copyWith(
      categoryId: categoryId,
      errors: {...state.errors}..remove('categoryId'),
    );
  }

  void updateIcon(String icon) {
    state = state.copyWith(
      icon: icon,
      errors: {...state.errors}..remove('icon'),
    );
  }

  void updatePurchasePrice(double price) {
    state = state.copyWith(
      purchasePrice: price,
      errors: {...state.errors}..remove('purchasePrice'),
    );
  }

  void updatePurchaseDate(DateTime date) {
    state = state.copyWith(
      purchaseDate: date,
      errors: {...state.errors}..remove('purchaseDate'),
    );
  }

  void updateWarrantyEndDate(DateTime? date) {
    state = state.copyWith(
      warrantyEndDate: date,
    );
  }

  void updateExpectedLifeDays(int? days) {
    state = state.copyWith(
      expectedLifeDays: days,
    );
  }

  void updateDepreciationMethod(DepreciationMethodPreference method) {
    state = state.copyWith(
      depreciationMethod: method,
      expectedLifeDays: method.defaultExpectedLifeDays,
    );
  }

  void updateStatus(AssetStatus status) {
    state = state.copyWith(
      status: status,
    );
  }

  void updateNote(String? note) {
    state = state.copyWith(
      note: note,
    );
  }

  // Validate form
  bool validate() {
    final errors = <String, String?>{};

    final nameError = ValidationService.validateAssetName(state.name);
    if (nameError != null) {
      errors['name'] = nameError;
    }

    final priceError =
        ValidationService.validatePurchasePrice(state.purchasePrice);
    if (priceError != null) {
      errors['purchasePrice'] = priceError;
    }

    final dateError =
        ValidationService.validatePurchaseDate(state.purchaseDate);
    if (dateError != null) {
      errors['purchaseDate'] = dateError;
    }

    final categoryError =
        ValidationService.validateCategoryId(state.categoryId);
    if (categoryError != null) {
      errors['categoryId'] = categoryError;
    }

    final iconError = ValidationService.validateIcon(state.icon);
    if (iconError != null) {
      errors['icon'] = iconError;
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  // Save asset (create or update)
  Future<bool> save() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(assetRepositoryProvider);

      final result = state.assetId == null
          ? await repository.createAsset(
              name: state.name,
              categoryId: state.categoryId,
              icon: state.icon,
              purchasePrice: state.purchasePrice,
              purchaseDate: state.purchaseDate,
              warrantyEndDate: state.warrantyEndDate,
              expectedLifeDays: state.expectedLifeDays,
              note: state.note,
            )
          : await repository.updateAsset(
              id: state.assetId!,
              name: state.name,
              categoryId: state.categoryId,
              icon: state.icon,
              purchasePrice: state.purchasePrice,
              purchaseDate: state.purchaseDate,
              warrantyEndDate: state.warrantyEndDate,
              expectedLifeDays: state.expectedLifeDays,
              status: state.status,
              note: state.note,
            );

      return result.when(
        success: (_) {
          // Invalidate asset list to refresh
          ref.invalidate(assetListProvider);
          state = state.copyWith(isLoading: false);
          return true;
        },
        failure: (error) {
          final message =
              error is AppException ? error.message : error.toString();
          state = state.copyWith(
            isLoading: false,
            errors: {'general': message},
          );
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errors: {'general': e.toString()},
      );
      return false;
    }
  }
}
