import 'dart:developer';
import 'package:care_nest/core/helpers/constants.dart';
import 'package:care_nest/core/helpers/shared_pref_helper.dart';
import 'package:care_nest/features/reminders/medications/data/models/add_medication_schedule/add_medication_schedule_request_body.dart';
import 'package:care_nest/features/reminders/medications/data/repos/add_medication_schedule_repo.dart';
import 'package:care_nest/features/reminders/medications/logic/add_medication_schedule_cubit/add_medication_schedule_state.dart';
import 'package:care_nest/features/reminders/medications/ui/widgets/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMedicationScheduleCubit extends Cubit<AddMedicationScheduleState> {
  AddMedicationScheduleCubit(this._medicationScheduleRepo)
      : super(const AddMedicationScheduleState.initial());

  final AddMedicationScheduleRepo _medicationScheduleRepo;
  TextEditingController medicationNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController beginController = TextEditingController();
  TextEditingController endController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Convert and bind time with timeController
  TimeOfDay? _time;
  TimeOfDay? get time => _time;
  set time(TimeOfDay? newTime) {
    _time = newTime;
    timeController.text = newTime != null
        ? "${newTime.hour}:${newTime.minute}" // تنسيق بسيط للوقت
        : '';
  }

  // Convert and bind begin date with beginController
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? newStartDate) {
    _startDate = newStartDate;
    beginController.text =
        newStartDate != null ? "${newStartDate.toLocal()}".split(' ')[0] : '';
  }

  // Convert and bind end date with endController
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? newEndDate) {
    _endDate = newEndDate;
    endController.text =
        newEndDate != null ? "${newEndDate.toLocal()}".split(' ')[0] : '';
  }

  void validateAndUpdateFields() {
    try {
      // التحقق من الحقول النصية وتحديث القيم
      if (timeController.text.isNotEmpty) {
        final timeParts = timeController.text.split(':');
        _time = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }

      if (beginController.text.isNotEmpty) {
        _startDate = DateTime.parse(beginController.text);
      }

      if (endController.text.isNotEmpty) {
        _endDate = DateTime.parse(endController.text);
      }
    } catch (e) {
      log("Error in parsing fields: $e");
    }
  }

  void addMedicationSchedule(String babyId) async {
    log('Starting medication schedule operation for baby with id: $babyId');
    emit(const AddMedicationScheduleState.addMedicationScheduleLoading());

    validateAndUpdateFields();

    if (_time == null || _startDate == null || _endDate == null) {
      log("Missing time or date fields");

      return;
    }

    String token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    log('Authorization Token Retrieved: $token');

    final response = await _medicationScheduleRepo.addMedicationSchedule(
      AddMedicationScheduleRequestBody(
        medicationName: medicationNameController.text,
        time: timeController.text,
        begin: beginController.text,
        end: endController.text,
      ),
      babyId,
      token,
    );

    response.when(
      success: (medicationScheduleResponse) async {
        log('Medication Schedule Success: $medicationScheduleResponse');
        emit(AddMedicationScheduleState.addMedicationScheduleSuccess(
            medicationScheduleResponse));
        scheduleNotificationForSpecificPeriod();
      },
      failure: (apiErrorModel) {
        emit(AddMedicationScheduleState.addMedicationScheduleError(
            apiErrorModel));
        log('Error Occurred: $apiErrorModel');
      },
    );
  }

  void scheduleNotificationForSpecificPeriod() async {
    if (_time == null || _startDate == null || _endDate == null) {
      log("Missing time or date fields");
      return;
    }
    final babyId =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.babyId);
    final babyName =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.babyName);
    NotificationService.scheduleMedicationNotificationWithPeriod(
      childId: babyId,
      medicationName: medicationNameController.text,
      time: _time!,
      startDate: _startDate!,
      endDate: _endDate!,
      childName: babyName,
    );
  }
}
