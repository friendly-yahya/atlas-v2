// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 List<ActivityCategory> get categories; String get searchQuery; Set<String> get selectedChips; Set<String> get selectedActivityIds; bool get isSubmitting; String? get errorMessage;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.selectedChips, selectedChips)&&const DeepCollectionEquality().equals(other.selectedActivityIds, selectedActivityIds)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),searchQuery,const DeepCollectionEquality().hash(selectedChips),const DeepCollectionEquality().hash(selectedActivityIds),isSubmitting,errorMessage);

@override
String toString() {
  return 'OnboardingState(categories: $categories, searchQuery: $searchQuery, selectedChips: $selectedChips, selectedActivityIds: $selectedActivityIds, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 List<ActivityCategory> categories, String searchQuery, Set<String> selectedChips, Set<String> selectedActivityIds, bool isSubmitting, String? errorMessage
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? searchQuery = null,Object? selectedChips = null,Object? selectedActivityIds = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<ActivityCategory>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedChips: null == selectedChips ? _self.selectedChips : selectedChips // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedActivityIds: null == selectedActivityIds ? _self.selectedActivityIds : selectedActivityIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ActivityCategory> categories,  String searchQuery,  Set<String> selectedChips,  Set<String> selectedActivityIds,  bool isSubmitting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.categories,_that.searchQuery,_that.selectedChips,_that.selectedActivityIds,_that.isSubmitting,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ActivityCategory> categories,  String searchQuery,  Set<String> selectedChips,  Set<String> selectedActivityIds,  bool isSubmitting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.categories,_that.searchQuery,_that.selectedChips,_that.selectedActivityIds,_that.isSubmitting,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ActivityCategory> categories,  String searchQuery,  Set<String> selectedChips,  Set<String> selectedActivityIds,  bool isSubmitting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.categories,_that.searchQuery,_that.selectedChips,_that.selectedActivityIds,_that.isSubmitting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({final  List<ActivityCategory> categories = const <ActivityCategory>[], this.searchQuery = '', final  Set<String> selectedChips = const <String>{}, final  Set<String> selectedActivityIds = const <String>{}, this.isSubmitting = false, this.errorMessage}): _categories = categories,_selectedChips = selectedChips,_selectedActivityIds = selectedActivityIds;
  

 final  List<ActivityCategory> _categories;
@override@JsonKey() List<ActivityCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  String searchQuery;
 final  Set<String> _selectedChips;
@override@JsonKey() Set<String> get selectedChips {
  if (_selectedChips is EqualUnmodifiableSetView) return _selectedChips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedChips);
}

 final  Set<String> _selectedActivityIds;
@override@JsonKey() Set<String> get selectedActivityIds {
  if (_selectedActivityIds is EqualUnmodifiableSetView) return _selectedActivityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedActivityIds);
}

@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._selectedChips, _selectedChips)&&const DeepCollectionEquality().equals(other._selectedActivityIds, _selectedActivityIds)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),searchQuery,const DeepCollectionEquality().hash(_selectedChips),const DeepCollectionEquality().hash(_selectedActivityIds),isSubmitting,errorMessage);

@override
String toString() {
  return 'OnboardingState(categories: $categories, searchQuery: $searchQuery, selectedChips: $selectedChips, selectedActivityIds: $selectedActivityIds, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 List<ActivityCategory> categories, String searchQuery, Set<String> selectedChips, Set<String> selectedActivityIds, bool isSubmitting, String? errorMessage
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? searchQuery = null,Object? selectedChips = null,Object? selectedActivityIds = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_OnboardingState(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ActivityCategory>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedChips: null == selectedChips ? _self._selectedChips : selectedChips // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedActivityIds: null == selectedActivityIds ? _self._selectedActivityIds : selectedActivityIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
