<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { PageProps } from '@/types';
import { MaterialResource } from '@/Resources/Material.resource';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { ref, shallowRef } from 'vue';
import CalculationHorizontalInputSection from '@/Components/Calculation/CalculationHorizontalInputSection.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const materials = usePage<PageProps<{ materials: Array<MaterialResource> }>>().props.materials;
const isolators = usePage<PageProps<{ isolators: Array<IsolatorResource> }>>().props.isolators;
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="card">
            <div class="grid">
                <div class="col-12">
                    <div class="text-900 font-medium text-xl mb-3">Ściany</div>
                    <p class="m-0 p-0 text-600 line-height-3 mr-3">Tutaj będą opisy poszczególnych sekcji</p>
                </div>
                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał Podstawowy</span>
                            </div>
                        </template>

                        <CalculationHorizontalInputSection label="Materiał podstawowy ściany" :col="12">
                            <!-- <CalculationAutoComplete
                                v-model="form.gsbmM"
                                label="Materiał izolacyjny podłogi"
                                :col="4"
                                :error-message="form.errors.gsbmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.gsbmD"
                                label="Grubość izolacyjny podłogi [m]"
                                :col="4"
                                :error-message="form.errors.gsbmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            /> -->
                        </CalculationHorizontalInputSection>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.ebmM"
                                label="Materiał podstawowy ściany"
                                :col="6"
                                :error-message="form.errors.ebmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.embD"
                                label="Grubość materiału podstawowego [m]"
                                :col="6"
                                :error-message="form.errors.embD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="mt-4">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał dodatkowy</span>
                            </div>
                        </template>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.esmM"
                                label="Materiał dodatkowy ściany"
                                :col="6"
                                :error-message="form.errors.esmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.esmD"
                                label="Grubość materiału dodatkowego [m]"
                                :col="6"
                                :error-message="form.errors.esmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="mt-4">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Izolacje</span>
                            </div>
                        </template>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.eimM"
                                label="Materiał izolacji ściany"
                                :col="6"
                                :error-message="form.errors.ebmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.eimD"
                                label="Grubość materiału izolacji [m]"
                                :col="6"
                                :error-message="form.errors.eimD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="mt-5">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Dodatkowe informacje</span>
                            </div>
                        </template>

                        <div class="formgrid p-fluid align-items-start">
                            <div class="items-center">
                                <Checkbox v-model="form.hasAirVoid" inputId="ingredient1" name="hasAirVoid" binary />
                                <label for="hasAirVoid" class="ml-2" :class="{ 'p-invalid': form.errors.hasAirVoid }">
                                    Ściana ma pustkę powietrzną
                                </label>
                            </div>

                            <div class="items-center mt-5">
                                <CalculationInput
                                    v-model="form.balL"
                                    label="Długość balkonów"
                                    :col="6"
                                    :error-message="form.errors.balL"
                                    :disabled="readonly"
                                    :readonly="readonly"
                                />
                            </div>
                        </div>
                    </Fieldset>
                </div>
            </div>
        </div>
    </component>
</template>
