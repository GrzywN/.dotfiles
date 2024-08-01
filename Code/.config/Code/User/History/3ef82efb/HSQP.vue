<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { PageProps } from '@/types';
import { WindowResource } from '@/Resources/Window.resource';
import { DoorResource } from '@/Resources/Door.resource';
import { ref, shallowRef } from 'vue';
import { getValuesFromProps } from '@/utils/getValuesFromProps';
import { EnumOptionsResource } from '@/Resources/EnumOptions.resource';
import WallDimensionPreview from '../WallDimensionPreview.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const windows = usePage<PageProps<{ windows: Array<WindowResource> }>>().props.windows;
const doors = usePage<PageProps<{ doors: Array<DoorResource> }>>().props.doors;

const { yearOfConstructionOptions } = getValuesFromProps<{ yearOfConstructionOptions: Array<EnumOptionsResource> }>();
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="card">
            <div class="grid">
                <div class="col-12 lg:col-2">
                    <div class="text-900 font-medium text-xl mb-3">Okna i drzwi</div>
                    <p class="m-0 p-0 text-600 line-height-3 mr-3">Tutaj będą opisy poszczególnych sekcji</p>
                </div>
                <div class="col-12 lg:col-10">
                    <div class="grid formgrid p-fluid">
                        <CalculationAutoComplete
                            v-model="form.uW"
                            label="Rodzaj okien"
                            :col="4"
                            :error-message="form.errors.uW"
                            :items="windows"
                            :disabled="readonly"
                        />
                        <CalculationAutoComplete
                            v-model="form.uD"
                            label="Rodzaj drzwi"
                            :col="4"
                            :error-message="form.errors.uD"
                            :items="doors"
                            :disabled="readonly"
                        />
                    </div>

                    <div class="input-grid"></div>

                    <WallDimensionPreview :width="form.bw ?? 1" :height="form.bl ?? 1" />

                    <div class="field mb-4 col-12 md:col-4">
                        <label for="input" class="font-medium text-900"> Rok okien </label>
                        <Dropdown
                            v-model="form.yearOfWindows"
                            :options="yearOfConstructionOptions"
                            optionLabel="label"
                            placeholder="Rok okien"
                            class="w-full"
                            :disabled="readonly"
                        />
                        <label class="p-error">{{ form.errors.yearOfWindows }}</label>
                    </div>

                    <div class="grid formgrid p-fluid">
                        <CalculationInput
                            v-model="form.aWN"
                            label="Powierzchnia okien skierowanych na ↑ PÓŁNOC [m²]"
                            :col="3"
                            :error-message="form.errors.aWN"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                        <CalculationInput
                            v-model="form.aWE"
                            label="Powierzchnia okien skierowanych na → WSCHÓD [m²]"
                            :col="3"
                            :error-message="form.errors.aWE"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                        <CalculationInput
                            v-model="form.aWS"
                            label="Powierzchnia okien skierowanych na ↓ POŁUDNIE [m²]"
                            :col="3"
                            :error-message="form.errors.aWS"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                        <CalculationInput
                            v-model="form.aWW"
                            label="Powierzchnia okien skierowanych na ← ZACHÓD [m²]"
                            :col="3"
                            :error-message="form.errors.aWW"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </div>
                    <div class="grid formgrid p-fluid">
                        <CalculationInput
                            v-model="form.ad"
                            label="Powierzchnia drzwi [m2]"
                            :col="3"
                            :error-message="form.errors.ad"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </div>
                </div>
            </div>
        </div>
    </component>
</template>

<style scoped>
.input-grid {
    display: grid;
    grid-template-areas:
        '. n .'
        'w c e'
        '. s .';
    grid-template-columns: 1fr 1fr 1fr;
}
</style>
