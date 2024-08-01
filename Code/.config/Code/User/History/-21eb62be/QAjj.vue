<script setup lang="ts">
defineProps<{
    width: number;
    height: number;
}>();
</script>

<template>
    <div class="inline-flex align-items-center text-center">
        <p class="mb-0 mr-1 rotate-180" style="writing-mode: vertical-lr">{{ height }} m</p>
        <div>
            <p class="mb-1">{{ width }} m</p>
            <div
                class="bg-primary-500 border-round-md"
                :class="{ 'w-8rem': width >= height, 'h-8rem': width <= height }"
                :style="{ aspectRatio: width / height }"
            />
            <p class="mt-1">{{ width }} m</p>
        </div>
        <p class="ml-1" style="writing-mode: vertical-lr">{{ height }} m</p>
    </div>
</template>
