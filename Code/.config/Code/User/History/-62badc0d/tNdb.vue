<script setup lang="ts">
import AppLayout from '@/layout/AppLayout.vue';
import { InertiaForm, usePage, router } from '@inertiajs/vue3';
import { initForm, formService, steps, CalculationForm } from '@/Pages/Calculation/Partials/config';
import { useToast } from 'primevue/usetoast';
import { computed, Ref, ref, watch } from 'vue';
import 'leaflet/dist/leaflet.css';
import { PageProps } from '@/types';
import { useToastHelper } from '@/Composables/useToastHelper';
import { Nullable } from 'primevue/ts-helpers';

const toast = useToast();
const { toastSuccess, toastError } = useToastHelper();

// const form = useForm<CalculationForm>(CalculationForm);

const form = defineModel<InertiaForm<CalculationForm>>('form', {
    default: initForm(),
});

// const form = initForm();

const parseFloatCommaToDot = (value: any) => {
    if (typeof value != 'string') {
        return value?.value;
    }

    return parseFloat(value.replaceAll(',', '.'));
};

const centimetersToMeters = (valueInCentimeters: Nullable<number>) => {
    if (valueInCentimeters == null) {
        return valueInCentimeters;
    }

    return valueInCentimeters / 100;
};

const submit = () => {
    form.value
        .transform((data) => {
            data = form.value?.data() || data; //todo: jakis dziwny bug ;o

            formService.setDataToStorage(data);
            return {
                draftData: data,

                ...data,
                ebmM: parseFloatCommaToDot(data.ebmM),
                eimM: parseFloatCommaToDot(data.eimM),
                bsbmM: parseFloatCommaToDot(data.bsbmM),
                bsimM: parseFloatCommaToDot(data.bsimM),
                gsimM: parseFloatCommaToDot(data.gsimM),
                ebbmM: parseFloatCommaToDot(data.ebbmM),
                ebimM: parseFloatCommaToDot(data.ebimM),
                asbmM: parseFloatCommaToDot(data.asbmM),
                asimM: parseFloatCommaToDot(data.asimM),
                esmM: parseFloatCommaToDot(data.esmM),
                uW: parseFloatCommaToDot(data.uW),
                uD: parseFloatCommaToDot(data.uD),
                lDrywall: parseFloatCommaToDot(data.lDrywall),
                rimM: parseFloatCommaToDot(data.rimM),
                roofAreaFactor: parseFloatCommaToDot(data.roofAreaFactor),
                gsbmM: parseFloatCommaToDot(data.gsbmM),
                gsbmM2: parseFloatCommaToDot(data.gsbmM2),
                gsimM2: parseFloatCommaToDot(data.gsimM2),
                climaticStation: data.climaticStation?.id,

                // Ogólne
                substrateType: data.substrateType?.value,
                yearOfConstruction: data.yearOfConstruction?.value,
                yearOfWindows: data.yearOfWindows?.value,
                roofInsulationType: data.roofInsulationType?.value,
                fh: centimetersToMeters(data.fh),

                // Ściany
                embD: centimetersToMeters(data.embD), // Grubość materiału podstawowego [cm]
                esmD: centimetersToMeters(data.esmD), // Grubość materiału dodatkowego [cm]
                balL: centimetersToMeters(data.balL), // Długość balkonów [cm]
                eimD: centimetersToMeters(data.eimD), // Grubość materiału izolacji [cm]
            };
        })
        .post(route('calculations.store'), {
            onError: (data) => {
                if (data.limitMessage) {
                    toast.add({
                        severity: 'error',
                        summary: data.limitMessage,
                        detail: 'Sprawdź czy masz aktywny pakiet',
                        life: 5000,
                    });
                }
            },
            onSuccess: () => {},
            preserveState: true,
            preserveScroll: true,
            // headers: {
            //     'X-Draft-Data': btoa(encodeURIComponent(JSON.stringify(form.value))),
            // },
        });
};

const propStepNumber = computed(() => usePage<PageProps<{ step: number }>>().props.step - 1);
const activeStep: Ref<number> = ref(propStepNumber.value);

watch(propStepNumber, (newVal) => {
    console.log('propStepNumber updated', propStepNumber);
    activeStep.value = newVal;
});

const saveDraft = () => {
    const dataString = formService.getDataFromLocalStorage();

    const restore = <CalculationForm>JSON.parse(dataString);
    if (!restore || !restore.climaticStation) {
        return toastError('Aby zapisać wzór, wybierz przynajmniej adres');
    }

    router.post(
        route('calculations.save-draft'),
        {
            draft: dataString,
        },
        {
            onSuccess: () => toastSuccess('Zapisano wzór'),
            onError: () => toastError('Nie udało się zapisać wzoru'),
        },
    );
};

defineExpose({
    submit,
});
</script>

<template>
    <AppLayout>
        <div class="card">
            <Steps
                :readonly="false"
                v-model:activeStep="activeStep"
                :model="steps"
                class="custom-steps"
                @update:active-step="
                    (step) =>
                        formService.changeStep(step, (updateStep: number) => {
                            activeStep = updateStep - 1;
                        })
                "
            >
                <template #item="{ item, active, index }">
                    <div
                        :class="[
                            'inline-flex align-items-center justify-content-center align-items-center border-circle border-primary border-1 h-3rem w-3rem z-1',
                            { 'bg-primary': active, 'surface-overlay text-primary': !active },
                            { 'cursor-pointer': activeStep > index },
                        ]"
                    >
                        <i :class="[item.icon, 'text-xl']" />
                    </div>
                    <div style="margin-left: -45px" class="mt-6">
                        {{ item.name }}
                    </div>
                </template>
            </Steps>
        </div>

        <slot />

        <div v-if="activeStep >= 1" class="card">
            <Button v-if="activeStep >= 1" severity="secondary" class="mr-4" label="Zapisz Draft" @click="saveDraft" />
            <Button v-if="activeStep >= 1" severity="info" label="Poprzedni krok" @click="formService.back" />
            <Button
                v-if="activeStep >= 1"
                severity="warning"
                class="ml-4 mr-4"
                label="Zacznij od początku"
                @click="formService.reset"
            />
            <Button :loading="form.processing" label="Następny krok" @click="submit" />
        </div>
    </AppLayout>
</template>
