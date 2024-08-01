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
import CalculationHorizontalInput from '@/Components/Calculation/CalculationHorizontalInput.vue';
import CalculationHorizontalAutoComplete from '@/Components/Calculation/CalculationHorizontalAutoComplete.vue';

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
                </div>
                <div class="col-12">
                    <div class="grid formgrid p-fluid">
                        <CalculationAutoComplete
                            v-model="form.uD"
                            label="Rodzaj drzwi"
                            :col="4"
                            :error-message="form.errors.uD"
                            :items="doors"
                            :disabled="readonly"
                        />
                    </div>

                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Rodzaj okien</span>
                            </div>
                        </template>

                        <CalculationHorizontalAutoComplete
                            v-model="form.uW"
                            label="Rodzaj okien"
                            :error-message="form.errors.uW"
                            :items="windows"
                            :disabled="readonly"
                        />

                        <CalculationHorizontalInput
                            label="Rok okien"
                            :error-message="form.errors.yearOfWindows"
                            :disabled="readonly"
                        >
                            <template #input>
                                <Dropdown
                                    v-model="form.yearOfWindows"
                                    :options="yearOfConstructionOptions"
                                    optionLabel="label"
                                    placeholder="Rok okien"
                                    class="w-full"
                                    :disabled="readonly"
                                />
                            </template>
                        </CalculationHorizontalInput>
                    </Fieldset>

                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Powierzchnia okien</span>
                            </div>
                        </template>

                        <div class="input-grid">
                            <div class="input-grid-center grid place-items-center">
                                <WallDimensionPreview class="mx-auto" :width="form.bw ?? 1" :height="form.bl ?? 1" />
                            </div>
                            <CalculationInput
                                class="input-grid-north"
                                v-model="form.aWN"
                                label="Powierzchnia okien skierowanych na ↑ PÓŁNOC [m²]"
                                :col="3"
                                :error-message="form.errors.aWN"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                class="input-grid-east"
                                v-model="form.aWE"
                                label="Powierzchnia okien skierowanych na → WSCHÓD [m²]"
                                :col="3"
                                :error-message="form.errors.aWE"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                class="input-grid-south"
                                v-model="form.aWS"
                                label="Powierzchnia okien skierowanych na ↓ POŁUDNIE [m²]"
                                :col="3"
                                :error-message="form.errors.aWS"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                class="input-grid-west"
                                v-model="form.aWW"
                                label="Powierzchnia okien skierowanych na ← ZACHÓD [m²]"
                                :col="3"
                                :error-message="form.errors.aWW"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Powierzchnia drzwi</span>
                            </div>
                        </template>

                        <CalculationHorizontalInput
                            v-model="form.ad"
                            label="Powierzchnia drzwi [m2]"
                            :error-message="form.errors.ad"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </Fieldset>
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
    grid-template-rows: 1fr max-content 1fr;
}

.input-grid-center {
    grid-area: c;
    display: grid;
    place-items: center;
}

.input-grid-north {
    grid-area: n;
    display: grid;
    place-items: center;
}

.input-grid-east {
    grid-area: e;
    display: grid;
    place-items: center;
}

.input-grid-south {
    grid-area: s;
    display: grid;
    place-items: center;
}

.input-grid-west {
    grid-area: w;
    display: grid;
    place-items: center;
}
</style>
