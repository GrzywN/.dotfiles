<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import { PageProps } from '@/types';
import { MaterialResource } from '@/Resources/Material.resource';
import { ref, shallowRef } from 'vue';
import { getValuesFromProps } from '@/utils/getValuesFromProps';
import { EnumOptionsResource } from '@/Resources/EnumOptions.resource';
import CalculationCheckbox from '@/Components/Calculation/CalculationCheckbox.vue';
import CalculationHorizontalInputSection from '@/Components/Calculation/CalculationHorizontalInputSection.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const materials = usePage<PageProps<{ materials: Array<MaterialResource> }>>().props.materials;

const { roofInsulationTypeList } = getValuesFromProps<{ roofInsulationTypeList: Array<EnumOptionsResource> }>();
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="card">
            <div class="grid">
                <div class="col-12 lg:col-2">
                    <div class="text-900 font-medium text-xl mb-3">Poddasze</div>
                </div>
                <pre>
    Czy poddasze jest ogrzewane?											checkbox


wysokość ściany kolankowej											input			m

Materiał podstawowy ściany											dropdown					input			cm

Materiał dodatkowy ściany											dropdown					input			cm

Materiał izolacji ściany											dropdown					input			cm

</pre
                >
                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Izolacja dachu</span>
                            </div>
                        </template>

                        <CalculationHorizontalInputSection label="Czy poddasze jest ogrzewane?" :col="12">
                            <CalculationCheckbox
                                class="ml-3"
                                v-model="form.hasBasement"
                                label="Czy poddasze jest ogrzewane?"
                                :col="4"
                                :readonly="readonly"
                                :disabled="readonly"
                                @update:model-value="() => (form.isBasementHeated = false)"
                            />
                        </CalculationHorizontalInputSection>
                    </Fieldset>

                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Izolacja dachu</span>
                            </div>
                        </template>
                    </Fieldset>

                    <div class="grid formgrid p-fluid align-items-end">
                        <Fieldset>
                            <template #legend>
                                <div class="flex align-items-center pl-2">
                                    <span class="font-bold">Materiał Podstawowy</span>
                                </div>
                            </template>

                            <CalculationAutoComplete
                                v-model="form.asbmM"
                                label="Materiał podstawowy poddasza"
                                :col="6"
                                :error-message="form.errors.asbmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.asbmD"
                                label="Grubość materiału podstawowego poddasza [m]"
                                :col="6"
                                :error-message="form.errors.asbmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </Fieldset>

                        <Fieldset>
                            <template #legend>
                                <div class="flex align-items-center pl-2">
                                    <span class="font-bold">Izolacja</span>
                                </div>
                            </template>

                            <CalculationAutoComplete
                                v-model="form.asimM"
                                label="Materiał izolacji poddasza"
                                :col="6"
                                :error-message="form.errors.asimM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.asimD"
                                label="Grubość materiału izolacji poddasza [m]"
                                :col="6"
                                :error-message="form.errors.asimD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </Fieldset>

                        <Fieldset>
                            <template #legend>
                                <div class="flex align-items-center pl-2">
                                    <span class="font-bold">Materiał Dodatkowy</span>
                                </div>
                            </template>

                            <CalculationAutoComplete
                                v-model="form.assmM"
                                label="Materiał dodatkowy poddasza"
                                :col="6"
                                :error-message="form.errors.assmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.assmD"
                                label="Grubość materiału dodatkowego poddasza [m]"
                                :col="6"
                                :error-message="form.errors.assmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </Fieldset>

                        <Fieldset>
                            <template #legend>
                                <div class="flex align-items-center pl-2">
                                    <span class="font-bold">Co dzieje się na dachu</span>
                                </div>
                            </template>

                            <Dropdown
                                v-model="form.roofInsulationType"
                                :options="roofInsulationTypeList"
                                optionLabel="label"
                                placeholder="Co dzieje się na dachu?"
                                class="w-full"
                                :disabled="readonly"
                            />

                            <label class="p-error mt-1">{{ form.errors.roofInsulationType }}</label>
                        </Fieldset>
                    </div>
                </div>
            </div>
        </div>
    </component>
</template>
